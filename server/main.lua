ESX = exports["es_extended"]:getSharedObject()


ESX.RegisterUsableItem(Config.Item, function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('mts_outfitbag:PutClotheBagDown', source)
    xPlayer.removeInventoryItem(Config.Item, 1)
end)

RegisterNetEvent('mts_outfitbag:addShoppingbag')
AddEventHandler('mts_outfitbag:addShoppingbag', function(object)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem(Config.Item, 1)
end)