-----------------------------------
---------- Discord Reports --------
---           by Badger         ---
-----------------------------------
-- Config --
webhookURL = ''
displayIdentifiers = true;

-- CODE --
function GetPlayers()
    local players = {}

    for _, i in ipairs(GetActivePlayers()) do
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
		if not displayIdentifiers then 
			sendToDisc("NEW REPORT: _[" .. tostring(id) .. "] " .. GetPlayerName(id) .. "_", 'Reason: **' .. message ..
				'**', "Reported by: [" .. source .. "] " .. GetPlayerName(source))
		else 
			-- Display the identifiers with the report 
			local ids = ExtractIdentifiers(id);
			local steam = ids.steam:gsub("steam:", "");
			local steamDec = tostring(tonumber(steam,16));
			steam = "https://steamcommunity.com/profiles/" .. steamDec;
			local gameLicense = ids.license;
			local discord = ids.discord;
			sendToDisc("NEW REPORT: _[" .. tostring(id) .. "] " .. GetPlayerName(id) .. "_", 
				'Reason: **' .. message ..
				'**\n' ..
				'Steam: **' .. steam .. '**\n' ..
				'GameLicense: **' .. gameLicense .. '**\n' ..
				'Discord Tag: **<@' .. discord:gsub('discord:', '') .. '>**\n' ..
				'Discord UID: **' .. discord:gsub('discord:', '') .. '**', "Reported by: [" .. source .. "] " .. GetPlayerName(source))
		end 
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
			["description"] = "" .. message ..  "",
			["footer"] = {
				["text"] = footer,
			},
		}
	}
	-- Start
	-- TODO Input Webhook
	PerformHttpRequest(webhookURL, 
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
	if IsPlayerAceAllowed(src, "BadgerReports.See") then 
		TriggerClientEvent('chatMessage', src, "^9[^1Report^9] ^8" .. msg)
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
function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    --Loop over all identifiers
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        --Convert it to a nice table.
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end