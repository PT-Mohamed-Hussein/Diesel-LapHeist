
function ShowHelpNotification(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function ShowNotification(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	DrawNotification(0,1)
end

RegisterNetEvent("Diesel-Lapheist:Client:FirstAlarm", function () -- this event will fire once the player has known the location of power station


end)

RegisterNetEvent("Diesel-Lapheist:Client:LastAlarm", function () -- this event will fire once all Station got blown


end)