ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports["es_extended"]:getSharedObject()
        Citizen.Wait(0)
    end
end)
local bag = false

exports.ox_target:addModel('v_ret_gc_bag02', {
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
})

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
        ESX.Game.SpawnObject('v_ret_gc_bag02', coords, function(obj)
            Wait(50)
            SetEntityHeading(obj, heading)
        end)
    end
end)

local isTimeoutActive = false

RegisterNetEvent('mts_outfitbag:CheckForOutfits')
AddEventHandler('mts_outfitbag:CheckForOutfits', function()
    if not isTimeoutActive then
        isTimeoutActive = true

        SetTimeout(Config.OpenDelay * 60 * 1000, function()
            isTimeoutActive = false
        end)


        exports['fivem-appearance']:openWardrobe(openWardrobe)
    else
        lib.notify({ title = 'Clothing bag', description = 'You can open the clothing bag once in '..Config.OpenDelay..' minutes', type = 'error' })
    end
end)

RegisterNetEvent('mts_outfitbag:pickupShoppingbag')
AddEventHandler('mts_outfitbag:pickupShoppingbag', function()
    local object = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 2.5, GetHashKey('v_ret_gc_bag02'))
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
