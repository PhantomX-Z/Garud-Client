-- Registerd on tab

local textures = {"Galaxy", "Tropical Sunnyday", "Cosmos", "Planet X"}
local selected_index = minetest.settings:get("skytexture") or 1

local function skies()
    return table.concat(textures, ",")
end

local settings = {

    -- Player
    {"priv_bypass", "Privbypass"},
    {"Point_Liquids", "Point Liquids"},
    {"dont_point_nodes", "Through Walls"},
    {"no_natural_damage", "No natural damage"},
    {"freecam", "Freecam"},
    -- Combat Cheats
    {"Killaura", "Killaura"},
    {"autoaim", "Aimbot"},
    {"autohit", "Auto Hit"},
   -- {"dodge", "Dodge (K)"},
    --{"autoescape", "Auto Escape (K)"},
    {"noknockback", "No Knockback"},

    -- Movement Cheats
    {"jetpack", "JetPack"},
    {"noslip", "No Slip"},
    {"spider", "Spider"},
    {"WOW", "Walk On Water"},
    {"customphysics", "Custom Physics"},

    -- Visual/ESP Cheats
    {"xray", "xray"},
    {"highlight_nodes", "Highlight nodes"},
    {"player_esp", "Player esp"},
    {"player_tracers", "Player tracers"},
    {"entity_esp", "Entity esp"},
    {"entity_tracers", "Entity tracers"},
    {"node_esp", "Node esp"},
    {"node_tracers", "Node tracers"},
    {"fullbright", "Fullbright"},

    -- Render Settings
    {"custom_sky", "Custom sky"},
    {"Moon", "Render Moon"},
    {"Sun", "Render Sun"},
    {"Nametags", "Render Nametags"},
    {"render_wield_items", "Render wield items"},
    {"No_Stars", "No Stars"},
    {"Clouds", "Clouds"},
    {"no_night", "No Night"},

    -- Other
    {"elysiummode", "Elysium Mode"}

}

local function create_formspec()
    local formspec = "size[19.2, 9;true]" ..
                     "no_prepend[]" ..
                     "real_coordinates[true]" ..
                     "outline[0,0;19.2,9;#D0D0D0]" ..
                     "bgcolor[#2D2D5A4A]" ..
                     "label[0.6,0.8;Cheat Menu]" ..
                     "button_exit[8,7.8;3.5,0.8;back;Back]"

    local checkbox_size = {x = 3, y = 0.5}
    local horizontal_spacing = 2.0
    local vertical_spacing = 0.001
    local num_per_column = 12
    local start_x = 0.6
    local start_y = 1.6

    for i, setting in ipairs(settings) do
        local setting_name, label = unpack(setting)
        local column = math.floor((i - 1) / num_per_column)
        local row = (i - 1) % num_per_column

        local x = start_x + column * (checkbox_size.x + horizontal_spacing)
        local y = start_y + row * (checkbox_size.y + vertical_spacing)

        local is_checked = minetest.settings:get(setting_name) == "true" and "true" or "false"
        formspec = formspec .. string.format("checkbox[%f,%f;toggle_%s;%s;%s]", x, y, setting_name, label, is_checked)
    end

    local xray_nodes_x = 14.8
    local xray_nodes_y = 1.8
    
    if minetest.settings:get("xray") == "true" then
        local xray_nodes = minetest.settings:get("xray_nodes") or ""
        formspec = formspec .. "style[xray_nodes;border=true;bgimg=field_bg.png;textcolor=#333333]" ..
                               string.format("field[%f,%f;4,0.56;xray_nodes;xray nodes;%s]", xray_nodes_x, xray_nodes_y, xray_nodes)

        if minetest.settings:get("node_esp") == "true" or minetest.settings:get("node_tracers") == "true" then
            local esp_nodes = minetest.settings:get("esp_nodes") or ""
            formspec = formspec .. "style[esp_nodes;border=true;textcolor=#333333]" ..
                                   string.format("field[%f,%f;4,0.56;esp_nodes;esp nodes;%s]", xray_nodes_x, xray_nodes_y + 1.1, esp_nodes)
            if minetest.settings:get("custom_sky") == "true" then
                formspec = formspec .. "label[" .. xray_nodes_x .. "," .. (xray_nodes_y + 2) .. ";Skies]" ..
                               string.format("dropdown[%f,%f;4,0.8;custom_sky;%s;%d]", xray_nodes_x, xray_nodes_y + 2.3, skies(), selected_index)
            end
        else
            if minetest.settings:get("custom_sky") == "true" then
                formspec = formspec .. "label[" .. xray_nodes_x .. "," .. (xray_nodes_y + 0.9) .. ";Skies]" ..
                               string.format("dropdown[%f,%f;4,0.8;custom_sky;%s;%d]", xray_nodes_x, xray_nodes_y + 1.2, skies(), selected_index)
            end
        end
    elseif minetest.settings:get("node_esp") == "true" or minetest.settings:get("node_tracers") == "true" then
        local esp_nodes = minetest.settings:get("esp_nodes") or ""
        formspec = formspec .. "style[esp_nodes;border=true;textcolor=#333333]" ..
                           string.format("field[%f,%f;4,0.56;esp_nodes;esp nodes;%s]", xray_nodes_x, xray_nodes_y, esp_nodes)
        if minetest.settings:get("custom_sky") == "true" then
            formspec = formspec .. "label[" .. xray_nodes_x .. "," .. (xray_nodes_y + 0.9) .. ";Skies]" ..
                           string.format("dropdown[%f,%f;4,0.8;custom_sky;%s;%d]", xray_nodes_x, xray_nodes_y + 1.1, skies(), selected_index)
        end
    else
        if minetest.settings:get("custom_sky") == "true" then
            formspec = formspec .. "label[" .. xray_nodes_x .. "," .. (xray_nodes_y - 0.2) .. ";Skies]" ..
                           string.format("dropdown[%f,%f;4,0.8;custom_sky;%s;%d]", xray_nodes_x, xray_nodes_y + 0.1, skies(), selected_index)
        end
    end

    return formspec
end

minetest.register_on_tab(function()
    minetest.show_formspec("settings_toggle:form", create_formspec())
end)

minetest.register_on_formspec_input(function(formname, fields)
    if formname ~= "settings_toggle:form" then
        return
    end

    for _, setting in ipairs(settings) do
        local setting_name = setting[1]
        local checkbox_field = "toggle_" .. setting_name
        if fields[checkbox_field] then
            local is_checked = fields[checkbox_field] == "true"
            minetest.settings:set(setting_name, is_checked and "true" or "false")
        end
    end
  
    if fields["toggle_xray"] or fields["toggle_node_esp"] or fields["toggle_node_tracers"] or fields["toggle_custom_sky"] then
        minetest.show_formspec("settings_toggle:form", create_formspec())
    end

    if fields["esp_nodes"] then
        local esp_nodes_input = fields["esp_nodes"] or ""
        minetest.settings:set("esp_nodes", esp_nodes_input)
    end

    if fields["xray_nodes"] then
        local xray_nodes_input = fields["xray_nodes"] or ""
        minetest.settings:set("xray_nodes", xray_nodes_input)
    end

    if fields["custom_sky"] then
        local selected_option = fields["custom_sky"]
        for index, option in ipairs(textures) do
            if selected_option == option then
                selected_index = index
                break
            end
        end
        if selected_index then
            minetest.settings:set("skytexture", selected_index)
        end
    end
    if fields["toggle_elysiummode"] == "true" then
        minetest.display_chat_message(minetest.colorize("#FFFDD0", "In elysium, killaura, player esp and tracers do not work due to the way the player's friendliness is checked (whether the player is to be ignored by killaura, esp and tracers or not) in this case use the elysium mode. (Use Elysium Mode when in Elysium only or it may break things.)"))
    end
    if fields["toggle_Killaura"] == "true" then
        minetest.display_chat_message(minetest.colorize("#FFFDD0", "Info: Addons of killaura end with (K). They require killaura to be turned on to work."))
    end

    if fields["toggle_custom_sky"] == "true" then
        minetest.settings:set("Sun", "false")
        minetest.settings:set("Moon", "false")
        minetest.settings:set("Clouds", "false")
        minetest.display_chat_message(minetest.colorize("#FF0000", "Note:" .. minetest.colorize("#FFFDD0", " Please leave and join after changing the skybox for the changes to apply.")))

    end

    if fields["toggle_customphysics"] == "false" then
        minetest.localplayer:set_physics_override({
            gravity = minetest.settings:get("ovgravity") or 1,
            speed = minetest.settings:get("ovspeed") or 1,
            jump = minetest.settings:get("ovjump") or 1,
            sneak = minetest.settings:get_bool("ovsneak") or true,
            sneak_glitch =  minetest.settings:get_bool("ovsneak_glitch") or false,
            new_move =  minetest.settings:get_bool("ovnewmove") or true,
        })
        minetest.display_chat_message(minetest.colorize("#00FF00", "Physics values set to servers defaults."))
    end
  
end)
