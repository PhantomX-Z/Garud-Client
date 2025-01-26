-- Used only for cheat hud


core.cheats = {
	["Cheats"] = {
		["xray"] = "xray",
		["Fullbright"] = "fullbright",
		["PrivBypass"] = "priv_bypass",
		["AutoRespawn"] = "autorespawn",
		["No Night"] = "no_night",
		["Point Liquids"] = "Point_Liquids",
		["WalkOnLiquids"] = "WOW",
		["Node ESP"] = "node_esp",
		["Node Tracers"] = "node_tracers",
		["Player ESP"] = "player_esp",
		["Player Tracers"] = "player_tracers",
		["Entity ESP"] = "entity_esp",
		["Entity Tracers"] = "entity_tracers",
		["Nametags"] = "Nametags",
		["Render Wield Items"] = "render_wield_items",
		["Moon"] = "Moon",
		["Sun"] = "Sun",
		["Clouds"] = "Clouds",
		["Highlight Nodes"] = "highlight_nodes",
		["No Stars"] = "No_Stars",
		["Killaura"] = "Killaura",
		["No Natural Damage"] = "no_natural_damage",
		["Dodge [K]"] = "dodge",
		["AutoEscape [K]"] = "autoescape",
		["Elysium Mode"] = "elysiummode",
		["No Knockback"] = "noknockback",
		["Jetpack"] = "jetpack",
		["No Slip"] = "noslip",
		["Spider"] = "spider",
		["Auto Aim"] = "autoaim",
		["Sneak Glitch"] = "sneakglitch",
		["Custom Sky"] = "custom_sky",
		["Auto Hit"] = "autohit",
		["Auto Place"] = "autoplace",
		["Auto Dig"] = "autodig",
		["Through Walls"] = "dont_point_nodes",
	},
}

function core.register_cheat(cheatname, category, func)
	core.cheats[category] = core.cheats[category] or {}
	core.cheats[category][cheatname] = func
end
