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
#include "chatmessage.h"
#include "core.h"
#include "client/camera.h"
#include "client/client.h"
#include "client/clientmap.h"
#include "client/hud.h"
#include "client/minimap.h"
#include "mapblock.h"
#include "mapsector.h"
#include "ISceneNode.h"
#include "client/content_cao.h"
#include "client/localplayer.h"
#include "gameparams.h"
#include "util/string.h"
#include "filesys.h"
using namespace irr::video;
RenderingCore::RenderingCore(IrrlichtDevice *_device, Client *_client, Hud *_hud)
	: device(_device), driver(device->getVideoDriver()), smgr(device->getSceneManager()),
	guienv(device->getGUIEnvironment()), client(_client), camera(client->getCamera()),
	mapper(client->getMinimap()), hud(_hud)
{
	screensize = driver->getScreenSize();
	virtual_size = screensize;
}

RenderingCore::~RenderingCore()
{
	clearTextures();
}

void RenderingCore::initialize()
{
	// have to be called late as the VMT is not ready in the constructor:
	initTextures();
}

void RenderingCore::updateScreenSize()
{
	virtual_size = screensize;
	clearTextures();
	initTextures();
}

void RenderingCore::draw(video::SColor _skycolor, bool _show_hud, bool _show_minimap,
		bool _draw_wield_tool, bool _draw_crosshair, bool _draw_node_esp, bool _draw_node_tracers, bool _draw_entity_esp, bool _draw_entity_tracers, bool _draw_player_esp, bool _draw_player_tracers)
{
	v2u32 ss = driver->getScreenSize();
	if (screensize != ss) {
		screensize = ss;
		updateScreenSize();
	}
	skycolor = _skycolor;
	show_hud = _show_hud;
	show_minimap = _show_minimap;
	draw_wield_tool = _draw_wield_tool;
	draw_crosshair = _draw_crosshair;
	draw_node_esp = _draw_node_esp;
	draw_node_tracers = _draw_node_tracers;
	draw_entity_esp = _draw_entity_esp;
	draw_entity_tracers =_draw_entity_tracers;
	draw_player_esp = _draw_player_esp;
	draw_player_tracers = _draw_player_tracers;
	beforeDraw();
	drawAll();
}




void RenderingCore::drawESPandTracers()
{
	ClientEnvironment &env = client->getEnv();
	Camera *camera = client->getCamera();
	v3f camera_offset = intToFloat(camera->getOffset(), BS);
	v3f eye_pos = (camera->getPosition() + camera->getDirection() - camera_offset);
 	video::SMaterial material, oldmaterial;
 	oldmaterial = driver->getMaterial2D();
	material.setFlag(video::EMF_LIGHTING, false);
	material.setFlag(video::EMF_BILINEAR_FILTER, false);
	material.setFlag(video::EMF_ZBUFFER, false);
	material.setFlag(video::EMF_ZWRITE_ENABLE, false);
	driver->setMaterial(material);
	Map &map = env.getMap();
    std::vector<v3s16> positions;
	map.listAllLoadedBlocks(positions);	
	ClientMap &clientMap = env.getClientMap();
	u8 wanted_range  = std::fmin(255.0f, clientMap.getWantedRange());
	LocalPlayer *player = env.getLocalPlayer();
	if (draw_entity_esp || draw_entity_tracers || draw_player_esp || draw_player_tracers) {
		auto allObjects = env.listallobjs();
		for (auto &it : allObjects) {
			ClientActiveObject *cao = it.second;
			if (cao->isLocalPlayer() || cao->getParent())
				continue;
			GenericCAO *obj = dynamic_cast<GenericCAO *>(cao);
			if (! obj)
				continue;
			const std::string &name = obj->getName();
			bool playerisfriend;
			std::vector<std::string> f = str_split(g_settings->get("friends"), ',');
        	for (std::vector<std::string>::iterator it = f.begin(); it != f.end(); it++) {
                if (name == *it) {
                	playerisfriend = true;
        		} else {
                    playerisfriend = false;
                }
			}
			bool is_player = obj->isplayer();
			bool is_friend = obj->isPlayerFriendly(obj);
			bool draw_esp = is_player ? draw_player_esp : draw_entity_esp;
			bool draw_tracers = is_player ? draw_player_tracers : draw_entity_tracers;
			video::SColor color = is_player ? enemy_esp_color : entity_esp_color;
			if (is_friend || playerisfriend)
				continue;
			if (! (draw_esp || draw_tracers))
				continue;
			aabb3f box;
			if (! obj->getSelectionBox(&box))
				continue;
			v3f pos = obj->getPosition() - camera_offset;
			box.MinEdge += pos;
			box.MaxEdge += pos;
			if (draw_esp)
				driver->draw3DBox(box, color);
			if (draw_tracers)
				driver->draw3DLine(eye_pos, box.getCenter(), color);
		}
	}

	if (draw_node_esp || draw_node_tracers) {
		for (v3s16 blockp : positions) {
			MapBlock *block = map.getBlockNoCreate(blockp);
			if (! block->mesh)
				continue;
			for (v3s16 p : block->mesh->esp_nodes) {
				v3f pos = intToFloat(p, BS) - camera_offset;
                if ((intToFloat(p, BS) - player->getPosition()).getLengthSQ() > (wanted_range*BS) * (wanted_range*BS))
     				continue;
				MapNode node = map.getNode(p);
				std::vector<aabb3f> boxes;
				node.getSelectionBoxes(client->getNodeDefManager(), &boxes, node.getNeighbors(p, &map));
				video::SColor c = client->getNodeDefManager()->get(node).minimap_color;
				video::SColor color = video::SColor(255, c.getRed(), c.getGreen(), c.getBlue());
				for (aabb3f box : boxes) {
					box.MinEdge += pos;
					box.MaxEdge += pos;
					if (draw_node_esp)
						driver->draw3DBox(box, color);
					if (draw_node_tracers)
						driver->draw3DLine(eye_pos, box.getCenter(), color);

				}
			}
		}
		driver->setMaterial(oldmaterial);
	}
}
void RenderingCore::draw3D()
{
	smgr->drawAll();
	driver->setTransform(video::ETS_WORLD, core::IdentityMatrix);
	if (!show_hud)
		return;
	hud->drawSelectionMesh();
	if (draw_node_esp || draw_node_tracers || draw_entity_esp || draw_entity_tracers || draw_player_esp || draw_player_tracers)
		drawESPandTracers();
	if (draw_wield_tool)
		camera->drawWieldedTool();
}

void RenderingCore::drawHUD()
{
	if (show_hud) {
		if (draw_crosshair)
			hud->drawCrosshair();
	
		hud->drawHotbar(client->getEnv().getLocalPlayer()->getWieldIndex());
		hud->drawLuaElements(camera->getOffset());
		camera->drawNametags();
		if (mapper && show_minimap)
			mapper->drawMinimap();
	}
	guienv->drawAll();
}

void RenderingCore::drawPostFx()
{
	client->getEnv().getClientMap().renderPostFx(camera->getCameraMode());
}
