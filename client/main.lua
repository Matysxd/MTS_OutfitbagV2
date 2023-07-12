ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports["es_extended"]:getSharedObject()
        Citizen.Wait(0)
    end
end)

local bag = false

exports.ox_target:addModel(Config.PropName, {
    {
        event = 'mts_outfitbag:pickupShoppingbag',
        icon = 'fas fa-hand-holding',
        label = Config.Lang.TakeBag,
    },
    {
        event = 'mts_outfitbag:CheckForOutfits',
        icon = 'fas fa-shopping-basket',
        label = Config.Lang.OpenWard,
    },
    {
        event = 'mts_outfitbag:moove',
        icon = 'fas fa-shopping-basket',
        label = Config.Lang.MoveBagTarget,
}}  )


RegisterNetEvent('mts_outfitbag:PutClotheBagDown')
AddEventHandler('mts_outfitbag:PutClotheBagDown', function()
    local coords = GetEntityCoords(PlayerPedId())
    coords = coords + vector3(0.0, 0.5, -0.93)
    local heading = GetEntityHeading(PlayerPedId())

    if lib.progressBar({
        duration = 1000,
        label = Config.Lang.Place,
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
        },
        anim = {
            dict = 'random@domestic',
            clip = 'pickup_low',
        },
    }) then
        bag = true
        ESX.Game.SpawnObject(Config.PropName, coords, function(obj)
            Wait(50)
            SetEntityHeading(obj, heading)
        end)
    end
end)

RegisterNetEvent('mts_outfitbag:CheckForOutfits')
AddEventHandler('mts_outfitbag:CheckForOutfits', function()
    if not isTimeoutActive then
        isTimeoutActive = true

        SetTimeout(Config.OpenDelay * 60 * 1000, function()
            isTimeoutActive = false
        end)
        

        if Config.Apparence == 'fivem-appearance' then
        exports['fivem-appearance']:openWardrobe(openWardrobe)
        elseif Config.Apparence == 'illenium-appearance' then
        TriggerEvent('illenium-appearance:client:openOutfitMenu')
        else
        end
    else
        lib.notify({ title = 'Clothing bag', description = 'You can open the clothing bag once in '..Config.OpenDelay..' minutes', type = 'error' })
    end
end)

RegisterNetEvent('mts_outfitbag:pickupShoppingbag')
AddEventHandler('mts_outfitbag:pickupShoppingbag', function()
    local object = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 2.5, GetHashKey(Config.PropName))
    if object ~= 0 then
        NetworkRequestControlOfEntity(object)
        while not NetworkHasControlOfEntity(object) do
            Wait(10)
        end
        TriggerServerEvent('mts_outfitbag:addShoppingbag', object)
        DeleteObject(object)
    else
        lib.notify({ title = 'Clothing bag', description = 'No bag found nearby.', type = 'error' })
    end
end)



AddEventHandler('onResourceStop', function(resourceName)
if (GetCurrentResourceName() ~= resourceName) then
    return
end
print('Script' .. resourceName .. ' was stopped.')
end)

AddEventHandler('onResourceStart', function(resourceName)
if (GetCurrentResourceName() ~= resourceName) then
    return
end
print('Script ' .. resourceName .. ' is starting.')
end)

