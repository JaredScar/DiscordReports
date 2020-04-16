-----------------------------------
---------- Discord Reports --------
---           by Badger         ---
-----------------------------------

RegisterNetEvent("Reports:CheckPermission:Client")
AddEventHandler("Reports:CheckPermission:Client", function(msg, error)
	TriggerServerEvent("Reports:CheckPermission", msg, false)
end)

--- Functions ---
function ShowInfo(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentSubstringPlayerName(text)
	DrawNotification(false, false)
end

