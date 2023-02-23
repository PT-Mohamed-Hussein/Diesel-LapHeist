
function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(50)
    end
end

function loadModel(model)
    if type(model) == 'number' then
        model = model
    else
        model = GetHashKey(model)
    end
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
end

function nearPowerStation()
    local ped = PlayerPedId()
    local pedCo = GetEntityCoords(ped)
    for k, v in pairs(Config.C4Zones) do
        if not v['plant'] then
            local dist = #(pedCo - v['pos'])
            if dist <= 1.5 then
                return true
            end
        end
    end
end

function noMorePowerStation()
    for k, v in pairs(Config.C4Zones) do
        if not v['plant'] then
            return false
        end
    end
    return true
end

function PlayCutscene(pid, cut, coords)
    while not HasThisCutsceneLoaded(cut) do 
        RequestCutscene(cut, 8)
        Wait(0) 
    end
    DoScreenFadeOut(10)

    CreateCutscene(pid, false, coords)
    RemoveCutscene()
end

function CreateCutscene(playerid, change, coords)
    local ped = GetPlayerPed(GetPlayerFromServerId(playerid))
        
    local clone = ClonePedEx(ped, 0.0, false, true, 1)
    local clone2 = ClonePedEx(ped, 0.0, false, true, 1)
    local clone3 = ClonePedEx(ped, 0.0, false, true, 1)
    local clone4 = ClonePedEx(ped, 0.0, false, true, 1)
    local clone5 = ClonePedEx(ped, 0.0, false, true, 1)

    SetBlockingOfNonTemporaryEvents(clone, true)
    SetEntityVisible(clone, false, false)
    SetEntityInvincible(clone, true)
    SetEntityCollision(clone, false, false)
    FreezeEntityPosition(clone, true)
    SetPedHelmet(clone, false)
    RemovePedHelmet(clone, true)
    
    if change then
        SetCutsceneEntityStreamingFlags('MP_2', 0, 1)
        RegisterEntityForCutscene(ped, 'MP_2', 0, GetEntityModel(ped), 64)
        
        SetCutsceneEntityStreamingFlags('MP_1', 0, 1)
        RegisterEntityForCutscene(clone2, 'MP_1', 0, GetEntityModel(clone2), 64)
    else
        SetCutsceneEntityStreamingFlags('MP_1', 0, 1)
        RegisterEntityForCutscene(ped, 'MP_1', 0, GetEntityModel(ped), 64)

        SetCutsceneEntityStreamingFlags('MP_2', 0, 1)
        RegisterEntityForCutscene(clone2, 'MP_2', 0, GetEntityModel(clone2), 64)
    end

    SetCutsceneEntityStreamingFlags('MP_3', 0, 1)
    RegisterEntityForCutscene(clone3, 'MP_3', 0, GetEntityModel(clone3), 64)
    
    SetCutsceneEntityStreamingFlags('MP_4', 0, 1)
    RegisterEntityForCutscene(clone4, 'MP_4', 0, GetEntityModel(clone4), 64)
    
    SetCutsceneEntityStreamingFlags('MP_5', 0, 1)
    RegisterEntityForCutscene(clone5, 'MP_5', 0, GetEntityModel(clone5), 64)
    DoScreenFadeIn(500)

    Wait(10)
    if coords then
        StartCutsceneAtCoords(coords, 0)
    else
        StartCutscene(0)
    end
    Wait(10)
    ClonePedToTarget(clone, ped)
    Wait(10)
    DeleteEntity(clone)
    DeleteEntity(clone2)
    DeleteEntity(clone3)
    DeleteEntity(clone4)
    DeleteEntity(clone5)
    Wait(50)
    DoScreenFadeIn(250)
end