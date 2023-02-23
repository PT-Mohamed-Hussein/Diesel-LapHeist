QBCore = exports['qb-core']:GetCoreObject()

local HiestState = {
    Robber = false,
    Started = false,
    Destroyed = false,
    BlackOut = false,
    isHackedSuccessfully = false,
    firstreward = false, 
    secondreward = false
}

local HasTalkedToAdminPrivillageNPC = false

local IsInsideZone = false

local remote = {}

local remoteLoop = false

local pressed = false

local blips = {}

local ped, ped2

local busy = false

local lapZone = PolyZone:Create({
    vector2(3611.4909667969, 3595.3312988281),
    vector2(3583.60546875, 3600.5827636719),
    vector2(3585.142578125, 3608.4692382813),
    vector2(3403.1823730469, 3641.6750488281),
    vector2(3409.6000976563, 3677.9812011719),
    vector2(3429.9919433594, 3748.2700195313),
    vector2(3418.9184570313, 3769.9616699219),
    vector2(3436.0283203125, 3778.1003417969),
    vector2(3455.2416992188, 3786.15234375),
    vector2(3462.6064453125, 3802.5),
    vector2(3477.4455566406, 3815.0180664063),
    vector2(3500.9438476563, 3822.4821777344),
    vector2(3586.9770507813, 3819.9741210938),
    vector2(3610.5231933594, 3817.2746582031),
    vector2(3628.8503417969, 3803.5187988281),
    vector2(3642.2019042969, 3783.1994628906),
    vector2(3649.9938964844, 3761.2590332031),
    vector2(3645.5544433594, 3736.1293945313),
    vector2(3651.9946289063, 3731.4306640625),
    vector2(3615.3681640625, 3693.2509765625),
    vector2(3611.998046875, 3650.8171386719),
    vector2(3619.8933105469, 3649.3432617188)
}, {
    name = "Humanelab",
    --minZ = 24.012470245361,
    --maxZ = 42.394882202148
})
  
lapZone:onPlayerInOut(function(isinside)
    if isinside and HiestState.BlackOut then 
        IsInsideZone = true
    else
        IsInsideZone = false
    end
end)

lapZone:onPlayerInOut(function(isinside)
    if (HiestState.Robber) and (not isinside) then 
        TriggerServerEvent('Diesel-Laphiest:Server:ResetHiest')
    end
end)

Citizen.CreateThread(function ()
    while true do 
        if IsInsideZone and HiestState.BlackOut then 
            SetArtificialLightsState(true)
        end
        Citizen.Wait(3)
    end
end)

Citizen.CreateThread(function ()
    while true do 
        if busy then 
            DisableAllControlActions(0)
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function ()
    RequestModel (Config.TakeAdminPrevillage.sourceped.model)
    while not HasModelLoaded(Config.TakeAdminPrevillage.sourceped.model) do
        Wait(100)
    end
    
    RequestModel (Config.StartHeistPed.model)
    while not HasModelLoaded(Config.StartHeistPed.model) do
        Wait(100)
    end

    ped = CreatePed (1, Config.TakeAdminPrevillage.sourceped.model, Config.TakeAdminPrevillage.sourceped.pos, false, false)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)

    ped2 = CreatePed (1, Config.StartHeistPed.model, Config.StartHeistPed.pos, false, false)
    SetEntityInvincible(ped2, true)
    SetBlockingOfNonTemporaryEvents(ped2, true)
    FreezeEntityPosition(ped2, true)

    exports['qb-target']:AddEntityZone("PedSourceAdminPrevilage", ped, {
        name = "PedSourceAdminPrevilage",
        heading = Config.TakeAdminPrevillage.sourceped.pos.w,
        debugPoly = false,
    }, {
        options = {
            {
                type = "client",
                event = "Diesel-LapHeist:Client:AskForLapPrevillage",
                icon = "fa-solid fa-laptop-code",
                label = "Ask For Admin Previllage",
            },
        },
        distance = 2.5
    })

    exports['qb-target']:AddEntityZone("PedStartHeist", ped2, {
        name = "PedStartHeist",
        heading = Config.StartHeistPed.pos.w,
        debugPoly = false,
    }, {
        options = {
            {
                type = "client",
                event = "Diesel-Lapheist:Client:StartHeist",
                icon = "fa-solid fa-laptop-code",
                label = "Ask For Power Station Location",
            },
        },
        distance = 2.5
    })
end)

for i, v in pairs (Config.C4Zones) do 
    exports['qb-target']:AddBoxZone(v.name, v.pos, v.length, v.width, {
        name = v.name,
        heading = v.heading,
        debugPoly = false,
        minZ = v.minz,
        maxZ = v.maxz
    }, {
        options = {
            {
                type = "client",
                event = "Diesel-Lapheist:Client:PlantC4Bomb",
                icon = "fas fa-bomb",
                label = "Plant C4",
                index = i,
                canInteract = function ()
                    if not v.plant and not busy then return true else return false end
                end
            },
        },
        distance = 2.5
    })
end

exports['qb-target']:AddBoxZone("hackzone", vector3(3611.73, 3729.06, 31.0), 1, 1, {
	name = "hackzone",
	heading = 325,
	debugPoly = false,
	minZ = 30.0,
    maxZ = 31.0
}, {
	options = {
		{
            type = "client",
            event = "Diesel-Lapheist:Client:StartHack",
			icon = "fas fa-desktop",
			label = "Start Hack",
		},
	},
	distance = 2.5
})

exports['qb-target']:AddBoxZone("firstlapwreward", vector3(3559.73, 3673.47, 28.12), 2.0, 2.6, {
	name = "firstlapwreward",
	heading = 350,
	debugPoly = false,
	minZ = 24.92,
    maxZ = 28.92
}, {
	options = {
		{
            type = "client",
            event = "Diesel-Lapheist:Client:LapFirstRewardZone",
			icon = "fas fa-radiation",
			label = "Search For Uranium",
		},
	},
	distance = 2.5
})

exports['qb-target']:AddBoxZone("secondlapreward", vector3(3539.58, 3668.8, 28.12), 1.0, 2.4, {
	name = "secondlapreward",
	heading = 346,
	debugPoly = false,
	minZ = 24.72,
    maxZ = 28.72
}, {
	options = {
		{
            type = "client",
            event = "Diesel-Lapheist:Client:LapSecondRewardZone",
			icon = "fas fa-radiation",
			label = "Search For Nuclear Codes",
		},
	},
	distance = 2.5
})

RegisterNetEvent('Diesel-LapHeist:Client:AskForLapPrevillage', function ()
    if not HasTalkedToAdminPrivillageNPC then 
        HasTalkedToAdminPrivillageNPC = true
        ShowNotification('Go To The Blip On The Map To Get The Codes')
        loadModel('baller')
        buyerBlip = addBlip(Config.TakeAdminPrevillage.destinationped, 500, 0, 'Codes Position')
        buyerVehicle = CreateVehicle(GetHashKey('baller'), Config.TakeAdminPrevillage.destinationped.xy + 3.0, Config.TakeAdminPrevillage.destinationped.z, 269.4, 0, 0)
        while true do
            local ped = PlayerPedId()
            local pedCo = GetEntityCoords(ped)
            local dist = #(pedCo - Config.TakeAdminPrevillage.destinationped)

            if dist <= 15.0 then
                QBCore.Functions.TriggerCallback('Diesel-LapHeist:Server:HaveCodesMoney', function(result)
                    if result then 
                        TriggerServerEvent('Diesel-LapHeist:Server:StartCutScene')
                        DeleteVehicle(buyerVehicle)
                        RemoveBlip(buyerBlip) 
                        HasTalkedToAdminPrivillageNPC = false
                    else
                        QBCore.Functions.Notify('The Sellers Found You Dont Have Money And Decide To Escape Out.')
                        DeleteVehicle(buyerVehicle)
                        RemoveBlip(buyerBlip)
                        HasTalkedToAdminPrivillageNPC = false
                    end
                end)
                break
            end
            Wait(100)
        end
    else
        QBCore.Functions.Notify('Sellers Waiting.')
    end
end)

RegisterNetEvent('Diesel-Lapheist:Client:StartCutScene', function(pid)
    local coords = GetEntityCoords(PlayerPedId())
    if #(coords - Config.TakeAdminPrevillage.destinationped) <= 50 then 
        PlayCutscene(pid, 'hs3f_all_drp3', Config.TakeAdminPrevillage.destinationped)
    end
end)

RegisterNetEvent('Diesel-Lapheist:Client:StartHeist', function ()
    QBCore.Functions.TriggerCallback('Diesel-LapHeist:Server:CheckPoliceCount', function(result)
        if result then
            QBCore.Functions.TriggerCallback('Diesel-LapHeist:Server:CheckCoolDown', function (result, timeleft)
                if result then 
                    HiestState.Robber = true
                    HiestState.Started = true
                    for i, v in pairs (Config.C4Zones) do 
                        blips[i] = addBlip(v.pos, 500, 0, 'Explosion Position '..i)
                    end
                    TriggerEvent("Diesel-Lapheist:Client:FirstAlarm")
                    ShowNotification('All Power Stations Supply Has Been Marked Successfully On The Map')
                    FreezeEntityPosition(ped2, false)
                    TaskGoToCoordAnyMeans (ped2, vector3(3515.07, 3796.35, 30.26), 1.0)
                    Citizen.CreateThread(function ()
                        while true do 
                            if #(GetEntityCoords(ped2) - vector3(3515.07, 3796.35, 30.26)) <= 15 then 
                                DeleteEntity(ped2)
                                break
                            end
                            Citizen.Wait(300)
                        end
                    end)
                else
                    QBCore.Functions.Notify('You Have To Wait .'.. timeleft, 'error')
                end
            end)
        else
            QBCore.Functions.Notify('Not Enough Police In Duty.', 'error', 5000)
        end
    end)
end)

RegisterNetEvent('Diesel-Lapheist:Client:PlantC4Bomb', function (data)
    print (HiestState.Robber, HiestState.Started,  HiestState.Destroyed)

    if HiestState.Robber and HiestState.Started then 
        QBCore.Functions.TriggerCallback('Diesel-Lapheist:Server:CheckC4PlantRequirement', function (result)
            if result then 
                if QBCore.Functions.HasItem(Config.C4BombItem) then 
                    busy = true
                    QBCore.Functions.TriggerCallback("Diesel-Labheist:Server:RemoveItem", function(removed)
                        if removed then
                            local ped = PlayerPedId()
                            local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
                            local animDict = 'anim@heists@ornate_bank@thermal_charge'
                            loadAnimDict(animDict)
                            loadModel(Config.Planting['objects'][1])
                            sceneObjectModel = 'prop_bomb_01'
                            
                            loadModel(sceneObjectModel)

                            bag = CreateObject(GetHashKey(Config.Planting['objects'][1]), pedCo, 1, 1, 0)
                            SetEntityCollision(bag, false, true)
                            
                            local object = GetClosestObjectOfType(Config.C4Zones[data.index].pos, 2.0, Config.C4PlantingObject)
                            local rot = GetEntityRotation (object)
                            local forward, right, up, pos = GetEntityMatrix(object)
                            local fx, fy, fz = table.unpack(forward)
                            local px, py, pz = table.unpack(pos)
                            
                            local newpos = vector3( px-(fx/2), py-(fy/2), pz + 1.1)
                            
                            Config.Planting['scenes'][1] = NetworkCreateSynchronisedScene(newpos, rot, 2, false, false, 1065353216, 0, 1.3)
                            TaskPlayAnim(ped, animDict, Config.Planting['animations'][1][1], 8.0, 8.0, -1, 48, 1, false, false, false)

                            NetworkAddPedToSynchronisedScene(ped, Config.Planting['scenes'][1], animDict, Config.Planting['animations'][1][1], 1.5, -4.0, 1, 16, 1148846080, 0)
                            NetworkAddEntityToSynchronisedScene(bag, Config.Planting['scenes'][1], animDict, Config.Planting['animations'][1][2], 4.0, -8.0, 1)

                            NetworkStartSynchronisedScene(Config.Planting['scenes'][1])
                            Wait(1500)
                            plantObject = CreateObject(GetHashKey(sceneObjectModel), pedCo, 1, 1, 0)
                            SetEntityCollision(plantObject, false, true)
                            AttachEntityToEntity(plantObject, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0.0, 0.0, 200.0, true, true, false, true, 1, true)
                            Wait(3000)

                            DeleteObject(bag)
                            DetachEntity(plantObject, 1, 1)
                            FreezeEntityPosition(plantObject, true)
                            Config.C4Zones[data.index].plant = true
                            table.insert(remote, {object = plantObject, coords = GetEntityCoords(plantObject)})
                        else
                            QBCore.Functions.Notify("You Need At Least 1 Of "..Config.C4BombItem, 'error')
                        end
                    end, Config.C4BombItem, 1)
                    
                    busy = false
                    if not remoteLoop then
                        remoteLoop = true
                        Citizen.CreateThread(function()
                            pressed = false
                            repeat
                                if not nearPowerStation() then
                                    ShowHelpNotification('Press [ E ] To Detonate Bombs')
                                    if IsControlJustPressed(0, 38) then
                                        loadAnimDict('anim@mp_player_intmenu@key_fob@')
                                        TaskPlayAnim(ped, "anim@mp_player_intmenu@key_fob@", "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
                                        Wait(500)
                                        for i =1, #remote do
                                            AddExplosion(remote[i].coords, 2, 300.0, 1)
                                            DeleteObject(remote[i].object)
                                        end
                                        if noMorePowerStation() then
                                            for i, v in pairs (blips) do
                                                RemoveBlip(v)
                                            end
                                            ShowNotification('Great! Power Will Cut Off Now But Security System Works On Backup Power Supply ')
                                            ShowNotification('U have Now To Move To Hack The Central Zone And Disable It I Have Marked It ')
                                            ShowNotification('To You On The Map')
                                            TriggerEvent("Diesel-Lapheist:Client:LastAlarm")

                                            local blip = addBlip(vector3(3611.73, 3729.06, 31.0), 500, 0, 'HacK Zone')
                                            table.insert(blips, blip)
                                            HiestState.Destroyed = true
                                            TriggerServerEvent('Diesel-Lapheist:Server:AllPowerStationDestroyed')
                                            Citizen.CreateThread(function ()
                                                Citizen.Wait(60000*8) -- 8 mins
                                                TriggerServerEvent('Diesel-Lapheist:Server:PowerBackToWork')
                                            end)
                                        end
                                        remote = {}
                                        pressed = true
                                        remoteLoop = false
                                    end
                                end
                                Citizen.Wait(1)
                            until pressed == true
                        end)
                    end
                else
                    QBCore.Functions.Notify("You Don't Have "..Config.C4BombItem, 'error')
                end
            else
               QBCore.Functions.Notify("You Doesn't Meet The Requirment To Plant C4", 'error')
            end
        end)
    else
        QBCore.Functions.Notify("You Doesn't Meet The Requirment To Plant C4", 'error')
    end
end)

RegisterNetEvent('Diesel-Lapheist:Client:DisableAllPower', function ()
    local coords = GetEntityCoords(PlayerPedId())
    HiestState.BlackOut = true
    if lapZone:isPointInside(coords) then 
        IsInsideZone = true
    end
end)

RegisterNetEvent('Diesel-Lapheist:Client:AllPowerBackToWork', function ()
    HiestState.BlackOut = false
end)

AddEventHandler ('QBCore:Client:OnPlayerLoaded', function ()
	QBCore.Functions.TriggerCallback('Diesel-Lapheist:Server:GetHeistStats', function(state) -- to keep sync of owned and closed state when the player joins the server
        HiestState.BlackOut = state['BlackOut']
	end)
end)

RegisterNetEvent('Diesel-Lapheist:Client:StartHack', function ()

    if HiestState.Robber and HiestState.Started and HiestState.Destroyed then
        QBCore.Functions.TriggerCallback('Diesel-Lapheist:Server:CheckHackRequirment', function (result)
            if result then
                if QBCore.Functions.HasItem(Config.LaptopHack) then 
                    local ped = PlayerPedId()
                    local pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
                    local animDict = 'anim@heists@ornate_bank@hack'

                    for k, v in pairs(Config.LaptopAnimation['objects']) do
                        loadModel(v)
                        Config.LaptopAnimation['sceneObjects'][k] = CreateObject(GetHashKey(v), pedCo, 1, 1, 0)
                    end
                
                    for i =1, #Config.LaptopAnimation['animations'] do
                        Config.LaptopAnimation['scenes'][i] = NetworkCreateSynchronisedScene(vector3(3611.73, 3729.06, 30.0), pedRotation, 2, true, false, 1065353216, 0, 1.3)
                        NetworkAddPedToSynchronisedScene(ped, Config.LaptopAnimation['scenes'][i], animDict, Config.LaptopAnimation['animations'][i][1], 1.5, -4.0, 1, 16, 1148846080, 0)
                        NetworkAddEntityToSynchronisedScene(Config.LaptopAnimation['sceneObjects'][1], Config.LaptopAnimation['scenes'][i], animDict, Config.LaptopAnimation['animations'][i][2], 4.0, -8.0, 1)
                        NetworkAddEntityToSynchronisedScene(Config.LaptopAnimation['sceneObjects'][2], Config.LaptopAnimation['scenes'][i], animDict, Config.LaptopAnimation['animations'][i][3], 4.0, -8.0, 1)
                        NetworkAddEntityToSynchronisedScene(Config.LaptopAnimation['sceneObjects'][3], Config.LaptopAnimation['scenes'][i], animDict, Config.LaptopAnimation['animations'][i][4], 4.0, -8.0, 1)
                    end
                
                    NetworkStartSynchronisedScene(Config.LaptopAnimation['scenes'][1])
                    Wait(6300)
                    NetworkStartSynchronisedScene(Config.LaptopAnimation['scenes'][2])
                    Wait(2000)
                    local hack = exports['Diesel-Hack']:Begin('lap')

                    NetworkStartSynchronisedScene(Config.LaptopAnimation['scenes'][3])
                    Wait(4600)
                
                    DeleteObject(Config.LaptopAnimation['sceneObjects'][1])
                    DeleteObject(Config.LaptopAnimation['sceneObjects'][2])
                    DeleteObject(Config.LaptopAnimation['sceneObjects'][3])

                    if hack == 'success' then 
                        for i, v in pairs (blips) do
                            RemoveBlip(v)
                        end
                        ShowNotification('Great! All Security Systems Are Down Now Move To Both Location Marked On Map For Rewards ')
                        local blip = addBlip(vector3(3559.73, 3673.47, 28.12), 500, 0, 'First Reward Zone')
                        table.insert(blips, blip)
                        local blip2 = addBlip(vector3(3539.58, 3668.8, 28.12), 500, 0, 'Second Reward Zone')
                        table.insert(blips, blip2)
                        HiestState.isHackedSuccessfully = true
                        TriggerServerEvent('Diesel-Lapheist:Server:HackedSuccessfully')
                        TriggerEvent('Diesel-lapheist:Client:SetDoorsOpenedState', false)
                    end
                else
                    QBCore.Functions.Notify("You Don't Have "..Config.LaptopHack, 'error')
                end
            else
                QBCore.Functions.Notify("You Doesn't Meet The Requirment To Start Hack", 'error')
            end
        end)
    else
        QBCore.Functions.Notify("You Doesn't Meet The Requirment To Start Hack", 'error')
    end
end)

RegisterNetEvent('Diesel-Lapheist:Client:LapFirstRewardZone', function ()
    if HiestState.Robber and HiestState.Started and HiestState.Destroyed and HiestState.isHackedSuccessfully and not HiestState.firstreward then 
        QBCore.Functions.TriggerCallback('Diesel-Lapheist:Server:CheckFirstRewardRequirments', function (result)
            if result then
                local ped = PlayerPedId()
                local animDict = 'missfbi5ig_22'
                local scenePos = vector3(3558.898, 3677.85, 27.125)
                local sceneRot vector3(0.0, 0.0, 170.0)
                loadAnimDict(animDict)
                
                SetEntityCoords(ped, scenePos)
                SetEntityHeading(ped, 170.0)

                pedCo, pedRotation = GetEntityCoords(ped), GetEntityRotation(ped)
                for i = 1, #Config.MiddleStageItem['objects'] do
                    loadModel(Config.MiddleStageItem['objects'][i])
                    Config.MiddleStageItem['sceneObjects'][i] = CreateObject(GetHashKey(Config.MiddleStageItem['objects'][i]), scenePos, 1, 1, 0)
                end

                for i = 1, #Config.MiddleStageItem['animations'] do
                    Config.MiddleStageItem['scenes'][i] = NetworkCreateSynchronisedScene(pedCo.xy, pedCo.z - 1.0, pedRotation, 2, true, false, 1065353216, 0, 1.1)
                    NetworkAddPedToSynchronisedScene(ped, Config.MiddleStageItem['scenes'][i], animDict, Config.MiddleStageItem['animations'][i][1], 4.0, -4.0, 1033, 0, 1000.0, 0)
                    NetworkAddEntityToSynchronisedScene(Config.MiddleStageItem['sceneObjects'][1], Config.MiddleStageItem['scenes'][i], animDict, Config.MiddleStageItem['animations'][i][2], 1.0, -1.0, 1148846080)
                    NetworkAddEntityToSynchronisedScene(Config.MiddleStageItem['sceneObjects'][2], Config.MiddleStageItem['scenes'][i], animDict, Config.MiddleStageItem['animations'][i][3], 1.0, -1.0, 1148846080)
                end
                
                cam = CreateCam("DEFAULT_ANIMATED_CAMERA", true)
                SetCamActive(cam, true)
                RenderScriptCams(true, 0, 3000, 1, 0)
                
                NetworkStartSynchronisedScene(Config.MiddleStageItem['scenes'][1])
                PlayCamAnim(cam, 'take_chemical_cam', animDict, pedCo.xy, pedCo.z - 1.0, pedRotation, 0, 2)
                Wait(GetAnimDuration(animDict, 'take_chemical_player0') * 1000)
                ClearPedTasks(ped)
                DeleteObject(Config.MiddleStageItem['sceneObjects'][1])
                RenderScriptCams(false, false, 0, 1, 0)
                DestroyCam(cam, false)
                for i = 1, #Config.MiddleStageItem['objects'] do
                    DeleteObject(Config.MiddleStageItem['sceneObjects'][i])
                end
                QBCore.Functions.TriggerCallback('Diesel-LapHiest:Server:GiveItem', function (result)
                    if result then 
                        HiestState.firstreward = true
                        TriggerServerEvent('Diesel-LapHiest:Server:SetFirstStageReward')
                    else
                        QBCore.Functions.Notify("QBCore:Notify", "Inventory Full", "error")
                    end
                end, Config.MiddleStageReward)                
            else
                QBCore.Functions.Notify("You Doesn't Meet The Requirment To Take First Reward", 'error')
            end
        end)
    else
        QBCore.Functions.Notify("You Doesn't Meet The Requirment To Take First Reward", 'error')
    end
end)

RegisterNetEvent('Diesel-Lapheist:Client:LapSecondRewardZone', function ()
    if HiestState.Robber and HiestState.Started and HiestState.Destroyed and HiestState.isHackedSuccessfully and HiestState.firstreward then 
        QBCore.Functions.TriggerCallback('Diesel-Lapheist:Server:CheckFinalRewardRequirments', function (result)
            if result then
                TriggerEvent('animations:client:EmoteCommandStart', {"mechanic4"})
                QBCore.Functions.Progressbar('Searching For Nuclear Codes', 'Searching For Nuclear Codes', 120000, false, true, {
                    disableMovement = true,
                    disableCarMovement = false,
                    disableMouse = true,
                    disableCombat = true,
                }, {}, {}, {},function()
                    money = true 
                    QBCore.Functions.TriggerCallback('Diesel-LapHiest:Server:GiveItem', function (result)
                        if result then 
                            HiestState.secondreward = false
                            TriggerServerEvent('Diesel-LapHiest:Server:SetSecondStageReward')
                        else
                            QBCore.Functions.Notify("QBCore:Notify", "Inventory Full", "error")
                        end
                    end, Config.LastStageItems)
                end)
            else
                QBCore.Functions.Notify("You Doesn't Meat Requirements To Take Last Stage Reward", 'error')
            end
        end)
    else
        QBCore.Functions.Notify("You Doesn't Meat Requirements To Take Last Stage Reward", 'error')
    end
end)

RegisterNetEvent('Diesel-Lapheist:Client:ResetHeist', function()
    HiestState = {
        Robber = false,
        Started = false,
        Destroyed = false,
        BlackOut = false,
        isHackedSuccessfully = false,
        firstreward = false, 
        secondreward = false
    }

    for i, v in pairs (blips) do
        RemoveBlip(v)
    end

    for i, v in pairs (Config.C4Zones) do
        v.plant = false
    end

    TriggerEvent('Diesel-lapheist:Client:SetDoorsOpenedState', true)

    DeleteEntity(ped2)

    ped2 = CreatePed (1, Config.StartHeistPed.model, Config.StartHeistPed.pos, false, false)
    SetEntityInvincible(ped2, true)
    SetBlockingOfNonTemporaryEvents(ped2, true)
    FreezeEntityPosition(ped2, true)
    exports['qb-target']:RemoveZone("PedStartHeist")

    exports['qb-target']:AddEntityZone("PedStartHeist", ped2, {
        name = "PedStartHeist",
        heading = Config.StartHeistPed.pos.w,
        debugPoly = false,
    }, {
        options = {
            {
                type = "client",
                event = "Diesel-Lapheist:Client:StartHeist",
                icon = "fa-solid fa-laptop-code",
                label = "Ask For Power Station Location",
            },
        },
        distance = 2.5
    })

end)

RegisterCommand('admin:laphiestlightson', function ()
    TriggerServerEvent('Diesel-Lapheist:Server:AdminForceLightsOn')
end)

