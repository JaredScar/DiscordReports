-----------------------------------
---------- Discord Reports --------
---           by Badger         ---
-----------------------------------

roleList = {
{0, "~w~"}, -- Regular Civilian / Non-Staff
{577631197987995678, "~r~STAFF ~w~"}, --[[ T-Mod --- 577631197987995678 ]] 
{506211787214159872, "~r~STAFF ~w~"}, --[[ Moderator --- 506211787214159872 ]]
{506212543749029900, "~r~STAFF ~w~"}, --[[ Admin --- 506212543749029900 ]]
{577966729981067305, "~p~MANAGEMENT ~w~"}, --[[ Management --- 577966729981067305 ]]
{506212786481922058, "~o~OWNER ~w~"}, --[[ Owner --- 506212786481922058]]
}

function GetPlayers()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

RegisterCommand("report", function(source, args, rawCommand)
    sm = stringsplit(rawCommand, " ");
    if #args < 2 then
    	TriggerClientEvent('chatMessage', source, "^1ERROR: Invalid Usage. ^2Proper Usage: /report <id> <reason>")
    	return;
    end
    id = sm[2]
    if GetPlayerIdentifiers(id)[1] == nil then
    	TriggerClientEvent('chatMessage', source, "^1ERROR: The specified ID is not currently online...")
    	return;
    end
	msg = ""
	local message = ""
	msg = msg .. " ^9(^6" .. GetPlayerName(source) .. "^9) ^1[^3" .. id .. "^1] "
	for i = 3, #sm do
		msg = msg .. sm[i] .. " "
		message = message .. sm[i] .. " "
	end
	-- TriggerClientEvent('chatMessage', source, "^9[^1Badger-Tags^9] ^3Your tag is now ^2active")
	-- TriggerClientEvent('SandyRestrictions:IsAOP:Return', -1, isSandyAOP, false)
	if tonumber(id) ~= nil then
		-- it's a number
		TriggerClientEvent("Reports:CheckPermission:Client", -1, msg, false)
		TriggerClientEvent('chatMessage', source, "^9[^1Badger-Reports^9] ^2Report has been submitted! Thank you for helping us :)")
		sendToDisc("NEW REPORT: _" .. tostring(id) .. " _", message, "[" .. source .. "] " .. GetPlayerName(source))
		--print("Runs report command fine and is number for ID") -- TODO - Debug
	else
		-- It's not a number
		TriggerClientEvent('chatMessage', source, "^9[^1Badger-Reports^9] ^1Invalid Format. ^1Proper Format: /report <id> <report>")
	end
end)

function sendToDisc(title, message, footer)
	local embed = {}
	embed = {
		{
			["color"] = 16711680, -- GREEN = 65280 --- RED = 16711680
			["title"] = "**".. title .."**",
			["description"] = "** " .. message ..  " **",
			["footer"] = {
				["text"] = footer,
			},
		}
	}
	-- Start
	PerformHttpRequest('', 
	function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
  -- END
end

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end
function sleep (a) 
    local sec = tonumber(os.clock() + a); 
    while (os.clock() < sec) do 
    end 
end

hasPermission = {}
doesNotHavePermission = {}

RegisterNetEvent("Reports:CheckPermission")
AddEventHandler("Reports:CheckPermission", function(msg, error)
	local src = source
	if not has_value(hasPermission, GetPlayerName(src)) and not has_value(doesNotHavePermission, GetPlayerName(src)) then
		for k, v in ipairs(GetPlayerIdentifiers(src)) do
				if string.sub(v, 1, string.len("discord:")) == "discord:" then
					identifierDiscord = v
				end
		end
		if identifierDiscord then
			local roleIDs = exports.discord_perms:GetRoles(src)
			if not (roleIDs == false) then
			local endLoop = false
				for i = 1, #roleList do
					if not endLoop then
						for j = 1, #roleIDs do
							if (tostring(roleList[i][1]) == tostring(roleIDs[j])) then
								-- Has permission to see the command
								TriggerClientEvent('chatMessage', src, "^9[^1Report^9] ^8" .. msg)
								table.insert(hasPermission, GetPlayerName(src))
								endLoop = true
								print("Has permission to see it, should see it") -- TODO - Debug, get rid of
							end
						end
					end
				end
			else
				-- Does not have permission to see the command
				print(GetPlayerName(src) .. " has not got permission to see reports cause roleIDs == false")
			end
		else
			-- Does not have permission to see the command cause no discord
		end
		if not has_value(hasPermission, GetPlayerName(src)) then
			table.insert(doesNotHavePermission, GetPlayerName(src))
			print(GetPlayerName(src) .. " added to doesNotHavePermission because they didn't have the discord role or error occurred...")
		end
	else
		-- Just print it for them
		if not has_value(doesNotHavePermission, GetPlayerName(src)) then
			TriggerClientEvent('chatMessage', src, "^9[^1Report^9] ^8" .. msg)
		end
	end
end)

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end