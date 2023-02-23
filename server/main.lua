QBCore = exports['qb-core']:GetCoreObject()

local HiestState = {
    ['Robber'] = 0,
    ['Started'] = false,
    ['Destroyed'] = false,
    ['BlackOut'] = false,
    ['isHackedSuccessfully'] = false,
    ['firstreward'] = false, 
    ['secondreward'] = false,
    ['cooldown'] = 0
}


RegisterNetEvent('Diesel-Lapheist:Server:AllPowerStationDestroyed', function ()
    if (HiestState['Started']) and (HiestState['Robber'] == source) then
        HiestState['Destroyed'] = true
        HiestState['BlackOut'] = true
        TriggerClientEvent('Diesel-Lapheist:Client:DisableAllPower', -1)
    end
end)

RegisterNetEvent('Diesel-Lapheist:Server:PowerBackToWork', function ()
    if (HiestState['Started']) and (HiestState['Robber'] == source) then
        HiestState['BlackOut'] = false
        TriggerClientEvent('Diesel-Lapheist:Client:AllPowerBackToWork', -1)
    end
end)

RegisterNetEvent('Diesel-Lapheist:Server:HackedSuccessfully', function ()
    if (HiestState['Destroyed']) and (HiestState['Robber'] == source) then
        HiestState['isHackedSuccessfully'] = true
    end
end)

RegisterNetEvent('Diesel-LapHiest:Server:SetFirstStageReward', function ()
    if (HiestState['isHackedSuccessfully']) and (HiestState['Robber'] == source) then
        HiestState['firstreward'] = true
    end
end)

RegisterNetEvent('Diesel-LapHiest:Server:SetSecondStageReward', function ()
    if (HiestState['firstreward']) and (HiestState['Robber'] == source) then
        HiestState['secondreward'] = true
    end
end)

RegisterNetEvent('Diesel-lapheist:Server:SetDoorsOpenedState', function (state)
    TriggerClientEvent('Diesel-lapheist:Client:SetDoorsOpenedState', -1, state)
end)

RegisterNetEvent('Diesel-LapHeist:Server:StartCutScene', function ()
    local src = source
    TriggerClientEvent('Diesel-Lapheist:Client:StartCutScene', -1, src)
end)

RegisterNetEvent('Diesel-Laphiest:Server:ResetHiest', function ()
    HiestState['Robber'] = 0
    HiestState['Started'] = false
    HiestState['Destroyed'] = false
    HiestState['BlackOut'] = false
    HiestState['isHackedSuccessfully'] = false
    HiestState['firstreward'] = false
    HiestState['secondreward'] = false


    TriggerClientEvent('Diesel-lapheist:Client:SetDoorsOpenedState', -1, false)

    TriggerClientEvent('Diesel-Lapheist:Client:ResetHeist', -1)

    for i, v in pairs (Config.C4Zones) do
        v.plant = false
    end

end)

RegisterNetEvent('Diesel-Lapheist:Server:AdminForceLightsOn', function()
    local src = source
    if QBCore.Functions.HasPermission(src, 'admin') or QBCore.Functions.HasPermission(src, 'superadmin') then 
        HiestState['BlackOut'] = false
        TriggerClientEvent('Diesel-Lapheist:Client:AllPowerBackToWork', -1)
    end
end)

function StartCooldown ()
    Citizen.CreateThread (function ()
        while HiestState['cooldown'] > 0 do
            Citizen.Wait(1000 * 60)
            HiestState['cooldown'] =  HiestState['cooldown'] - 1
        end
    end)
end

QBCore.Functions.CreateCallback ('Diesel-Lapheist:Server:GetHeistStats', function(src, cb)
    cb(HiestState)
end)

QBCore.Functions.CreateCallback('Diesel-LapHeist:Server:CheckPoliceCount', function(source, cb)
    local players = QBCore.Functions.GetPlayers()
    local policeCount = 0

    for i = 1, #players do
        local player = QBCore.Functions.GetPlayer(players[i])
        if player.PlayerData.job.name == 'police' and player.PlayerData.job.onduty then
            policeCount = policeCount + 1
        end
    end

    if policeCount >= Config.RequiredPoliceCount then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback ('Diesel-LapHeist:Server:CheckCoolDown', function(src, cb)
    if HiestState['cooldown'] <= 0 then
        HiestState['cooldown'] = Config.CoolDown
        HiestState['Started'] = true
        HiestState['Robber'] = src
        StartCooldown()
        cb(true)
    else
        cb(false, HiestState['cooldown'])
    end
end)

QBCore.Functions.CreateCallback ('Diesel-LapHeist:Server:HaveCodesMoney', function (src, cb)
    local Player = QBCore.Functions.GetPlayer(src)
    local money = Player.Functions.GetMoney('cash')
    local bank = Player.Functions.GetMoney('bank')
    local username, password = exports['Diesel-Hack']:GetHackInfo('lap')
    local itemData = QBCore.Shared.Items.lapadminprivelage

    local info = {}

    info.username = username
    info.password = password
					
    if (money >= Config.CodesPrice and CanCarryItem(src, "lapadminprivelage", 1))  then 
        Player.Functions.RemoveMoney('cash', Config.CodesPrice, 'Lap Codes')
        Player.Functions.AddItem("lapadminprivelage", 1, false, info)

        cb(true)
    elseif (bank >= Config.CodesPrice and CanCarryItem(src, "lapadminprivelage", 1)) then
        Player.Functions.RemoveMoney('bank', Config.CodesPrice, 'Lap Codes')
        Player.Functions.AddItem("lapadminprivelage", 1, false, info)

        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback ('Diesel-Lapheist:Server:GetHackedState', function (source, cb)
    cb(HiestState['isHackedSuccessfully'])
end)

QBCore.Functions.CreateCallback ('Diesel-Lapheist:Server:CheckHackRequirment', function (src, cb)
    if (HiestState['Robber'] == src) and (HiestState['Started']) and (HiestState['Destroyed']) then 
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback ('Diesel-Lapheist:Server:CheckC4PlantRequirement', function (src, cb)
    if (HiestState['Robber'] == src) and (HiestState['Started']) then 
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback ('Diesel-Lapheist:Server:CheckFirstRewardRequirments', function (src, cb)
    if (HiestState['Robber'] == src) and (HiestState['Started']) and (HiestState['Destroyed']) and (HiestState['isHackedSuccessfully']) and not(HiestState['firstreward']) then 
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback ('Diesel-Lapheist:Server:CheckFinalRewardRequirments', function (src, cb)
    if (HiestState['Robber'] == src) and (HiestState['firstreward']) and not(HiestState['secondreward']) then 
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback ('Diesel-LapHiest:Server:GiveItem', function (src, cb, item)
    local Player = QBCore.Functions.GetPlayer(src)
    if (Player.Functions.AddItem(item.name, item.count)) then 
        cb(true)
    else
        cb(false)
    end
end)


QBCore.Functions.CreateCallback("Diesel-Labheist:Server:RemoveItem",function(source, cb, item, amount)
    amount = amount or 1

    local Player = QBCore.Functions.GetPlayer(source)

    if Player.Functions.RemoveItem(item, amount) then
        cb(true)
    else
        cb(false)
    end

end)

Citizen.CreateThread(function ()
    while true do 
        if HiestState['Robber'] ~= 0 then 
            local Player = QBCore.Functions.GetPlayer(HiestState['Robber'])
            if not Player then 
                TriggerEvent('Diesel-Laphiest:Server:ResetHiest')
            end
        end
        Citizen.Wait(20000)
    end
end)
