ESX = exports["es_extended"]:getSharedObject() -- ESX export, niet aan zitten.

-- Give item to player once delivering package
RegisterNetEvent('deliveryReward')
AddEventHandler('deliveryReward', function(inDienst)
    if inDienst == true then
        exports.ox_inventory:AddItem(source, Luca.Item, Luca.ItemCount)
    end
end)
