-- Minetest: builtin/client/chatcommands.lua

function roundto2(num)
    return math.floor(num * 100 + 0.5) / 100
end
core.register_on_sending_chat_message(function(message)
	if message:sub(1,2) == ".." then
		return false
	end

	local first_char = message:sub(1,1)
	if first_char == "/" or first_char == "." then
		core.display_chat_message(core.gettext("issued command: ") .. message)
	end

	if first_char ~= "." then
		return false
	end

	local cmd, param = string.match(message, "^%.([^ ]+) *(.*)")
	param = param or ""

	if not cmd then
		core.display_chat_message(core.gettext("-!- Empty command"))
		return true
	end

	-- Run core.registered_on_chatcommand callbacks.
	if core.run_callbacks(core.registered_on_chatcommand, 5, cmd, param) then
		return true
	end

	local cmd_def = core.registered_chatcommands[cmd]
	if cmd_def then
		core.set_last_run_mod(cmd_def.mod_origin)
		local _, result = cmd_def.func(param)
		if result then
			core.display_chat_message(result)
		end
	else
		core.display_chat_message(core.gettext("-!- Invalid command: ") .. cmd)
	end

	return true
end)
-- Green #00FF00
-- Red #FF0000
core.register_chatcommand("autoplace", {
	description = "Autoplace. <on>, <off>",
	func = function(param)
		if param == nil then
			minetest.display_chat_message(minetest.colorize("#FF0000", "Invalid usage of command."))
			return
		elseif param == "" then
			minetest.display_chat_message(minetest.colorize("#00FF00", "Autoplace: " .. minetest.settings:get("autoplace")))
			return
		elseif param == "on" then
			minetest.settings:set("autoplace", "true")
			minetest.display_chat_message(minetest.colorize("#00FF00", "Auto place is enabled."))
		elseif param == "off" then 
			minetest.settings:set("autoplace", "false")
			minetest.display_chat_message(minetest.colorize("#FF0000", "Auto place is disabled."))
		end
		

	end
})
core.register_chatcommand("autodig", {
	description = "Autodig. <on>, <off>",
	func = function(param)
		if param == nil then
			minetest.display_chat_message(minetest.colorize("#FF0000", "Invalid usage of command."))
			return
		elseif param == "" then
			minetest.display_chat_message(minetest.colorize("#00FF00", "Autodig: " .. minetest.settings:get("autodig")))
			return
		elseif param == "on" then
			minetest.settings:set("autodig", "true")
			minetest.display_chat_message(minetest.colorize("#00FF00", "Autodig is enabled."))
		elseif param == "off" then 
			minetest.settings:set("autodig", "false")
			minetest.display_chat_message(minetest.colorize("#FF0000", "Autodig is disabled."))
		end
		

	end
})
core.register_chatcommand("fastdig", {
	description = "Fastplace. <on>, <off>",
	func = function(param)
		if param == nil then
			minetest.display_chat_message(minetest.colorize("#FF0000", "Invalid usage of command."))
			return
		elseif param == "" then
			minetest.display_chat_message(minetest.colorize("#00FF00", "Fastdig: " .. minetest.settings:get("fastdig")))
			return
		elseif param == "on" then
			minetest.settings:set("fastdig", "true")
			minetest.display_chat_message(minetest.colorize("#00FF00", "Fastdig is enabled."))
		elseif param == "off" then 
			minetest.settings:set("fastdig", "false")
			minetest.display_chat_message(minetest.colorize("#FF0000", "Fastdig is disabled."))
		end
		

	end
})
core.register_chatcommand("sneak", {
	description = "Set if we can sneak or not. <on>, <off>",
	func = function(param)
		if param == nil or param == "" then
			minetest.display_chat_message(minetest.colorize("#FF0000", "Invalid usage of command."))
			return
		elseif minetest.settings:get("customphysics") ~= "true" then
			minetest.display_chat_message(minetest.colorize("#FF0000", "Enable custom physics to use this command."))
			return
		elseif param == "on" then
			minetest.localplayer:set_physics_override({sneak = true})
			minetest.display_chat_message(minetest.colorize("#00FF00", "Sneak is enabled."))
		elseif param == "off" then 
			minetest.localplayer:set_physics_override({sneak = false})
			minetest.display_chat_message(minetest.colorize("#FF0000", "Sneak is disabled."))
		end
		

	end
})

core.register_chatcommand("sneak_glitch", {
	description = "Set sneak glitch to be enabled or disabled. <on>, <off>",
	func = function(param)
	
		if param == nil or param == "" then
			minetest.display_chat_message(minetest.colorize("#FF0000", "Invalid usage of command."))
			return
		elseif minetest.settings:get("customphysics") ~= "true" then
			minetest.display_chat_message(minetest.colorize("#FF0000", "Enable custom physics to use this command."))
			return
		elseif param == "on" then
			minetest.localplayer:set_physics_override({sneak_glitch = true})
			minetest.display_chat_message(minetest.colorize("#00FF00", "Sneak Glitch enabled."))
		elseif param == "off" then 
			minetest.localplayer:set_physics_override({sneak_glitch = false})
			minetest.display_chat_message(minetest.colorize("#FF0000", "Sneak Glitch disabled."))
		end
		

	end
})

core.register_chatcommand("newmove", {
	description = "Set if we have to use the new movement code or the old one. <on>, <off>",
	func = function(param)

		if param == nil or param == "" then
			minetest.display_chat_message(minetest.colorize("#FF0000", "Invalid usage of command."))
			return
		elseif minetest.settings:get("customphysics") ~= "true" then
			minetest.display_chat_message(minetest.colorize("#FF0000", "Enable custom physics to use this command."))
			return
		elseif param == "on" then
			minetest.localplayer:set_physics_override({new_move = true})
			minetest.display_chat_message(minetest.colorize("#00FF00", "New move is enabled."))
		elseif param == "off" then 
			minetest.localplayer:set_physics_override({new_move = false})
			minetest.display_chat_message(minetest.colorize("#FF0000", "New move is disabled."))
		end

	end
})

core.register_chatcommand("gravity", {
	description = "Set gravity of the player. (Requires custom physics to be enabled)",
	func = function(param)
		if param == nil or param == "" then
			minetest.display_chat_message(minetest.colorize("#FF0000", "Invalid usage of command."))
			return
		elseif minetest.settings:get("customphysics") ~= "true" then
			minetest.display_chat_message(minetest.colorize("#FF0000", "Enable custom physics to use this command."))
			return
		elseif param == "help" then
			minetest.display_chat_message(minetest.colorize("#00FF00", "Set gravity of the player. Min - 0.1, lower could break things."))
			return
		end
		minetest.localplayer:set_physics_override({ gravity = tonumber(param) })
		minetest.display_chat_message(minetest.colorize("#00FF00", "Gravity set to " .. param .. "."))

		
	end

})

core.register_chatcommand("speed", {
	description = "Set speed of the player. (Requires custom physics to be enabled)",
	func = function(param)
		if param == nil or param == "" then
			minetest.display_chat_message(minetest.colorize("#FF0000", "Invalid usage of command."))
			return
		elseif minetest.settings:get("customphysics") ~= "true" then
			minetest.display_chat_message(minetest.colorize("#FF0000", "Enable custom physics to use this command."))
			return
		elseif param == "help" then
			minetest.display_chat_message(minetest.colorize("#00FF00", "Set speed of the player."))
			return
		end
		minetest.localplayer:set_physics_override({ speed = tonumber(param) })
		minetest.display_chat_message(minetest.colorize("#00FF00", "Speed set to " .. param .. "."))


	end

})

core.register_chatcommand("jump", {
	description = "Set jump of the player. (Requires custom physics to be enabled)",
	func = function(param)
		if param == nil or param == "" then
			minetest.display_chat_message(minetest.colorize("#FF0000", "Invalid usage of command."))
			return
		elseif minetest.settings:get("customphysics") ~= "true" then
			minetest.display_chat_message(minetest.colorize("#FF0000", "Enable custom physics to use this command."))
			return
		elseif param == "help" then
			minetest.display_chat_message(minetest.colorize("#00FF00", "Set jump of the player. Min - 0.1, lower could break things."))
			return
		end
		minetest.localplayer:set_physics_override({ jump = tonumber(param) })
		minetest.display_chat_message(minetest.colorize("#00FF00", "Jump set to " .. param .. "."))

	end
})

core.register_chatcommand("physics", {
	description = "<>, display the current physics values. <help> shows this message.",
	func = function(param)
		local cso = minetest.localplayer:get_physics_override()
	
		if param == nil then
			minetest.display_chat_message(minetest.colorize("#FF0000", "Invalid usage of command."))
			return
		elseif param == "help" then
			minetest.display_chat_message(minetest.colorize("#00FF00", "<>, display the current physics values. <help> shows this message."))
			return
		elseif param == "" then
			minetest.display_chat_message(minetest.colorize("#00FF00", "Gravity: " .. roundto2(cso.gravity) .. "\n" .. "Jump: " .. roundto2(cso.jump) .. "\n" .. "Speed: " .. roundto2(cso.speed) .. "\n" .. "Sneak: " .. tostring(cso.sneak) .. "\n" .. "Sneak Glitch: " .. tostring(cso.sneak_glitch) .. "\n" .. "New move: " .. tostring(cso.new_move)))
		end
		
	end

})
core.register_chatcommand("reachd", {
	description = "Set reach distance.",
	func = function(param)

		local success, newd = core.parse_num(param)
		if param == nil then 
			return false, "Invalid usage of command."
		elseif param == "" then
			minetest.display_chat_message("Current reach distance is " .. minetest.colorize("#FF0000", tostring(core.settings:get("reachd")) .. " blocks."))
		elseif tonumber(newd) > 10 then
			minetest.display_chat_message(minetest.colorize("#FF0000", "Its is only adviced to use reach distances above 10 while using guns with autoaim."))
		elseif success and tonumber(newd) <= 10 then
			core.settings:set("reachd", tonumber(newd))
			return true, "Reach distance set to " .. minetest.colorize("#FF0000", newd) .. " blocks."
		end
	end
})

core.register_list_command("friends", "Killaura, ESP, tracers and autoaim ignores players in this list.", "ally")
core.register_chatcommand("players", {
	description = core.gettext("List online players"),
	func = function(param)
		local player_names = core.get_player_names()
		if not player_names then
			return false, core.gettext("This command is disabled by server.")
		end

		local players = table.concat(player_names, ", ")
		return true, core.gettext("Online players: ") .. players
	end
})

core.register_chatcommand("disconnect", {
	description = core.gettext("Exit to main menu"),
	func = function(param)
		core.disconnect()
	end,
})

core.register_chatcommand("clear_chat_queue", {
	description = core.gettext("Clear the out chat queue"),
	func = function(param)
		core.clear_out_chat_queue()
		return true, core.gettext("The out chat queue is now empty")
	end,
})

function core.run_server_chatcommand(cmd, param)
	core.send_chat_message("/" .. cmd .. " " .. param)
end


core.register_chatcommand("set", {
        params = "([-n] <name> <value>) | <name>",
        description = "Set or read client configuration setting",                                       
		func = function(param)
                local arg, setname, setvalue = string.match(param, "(-[n]) ([^ ]+) (.+)")
                if arg and arg == "-n" and setname and setvalue then
                        core.settings:set(setname, setvalue)
                        return true, setname .. " = " .. setvalue
                end

                setname, setvalue = string.match(param, "([^ ]+) (.+)")
                if setname and setvalue then
                        if not core.settings:get(setname) then
                                return false, "Failed. Use '.set -n <name> <value>' to create a new setting."
                        end
                        core.settings:set(setname, setvalue)
                        return true, setname .. " = " .. setvalue
                end

                setname = string.match(param, "([^ ]+)")
                if setname then
                        setvalue = core.settings:get(setname)
                        if not setvalue then
                                setvalue = "<not set>"
                        end
                        return true, setname .. " = " .. setvalue
                end

                return false, "Invalid parameters (see .help set)."
        end,
})
