ESX = exports["es_extended"]:getSharedObject() -- ESX export, dont touch
local loodsOwner = ESX.PlayerData.identifier
local inDienst



-- Spawn vehicle when starting job
local function spawnVeh()
    ESX.Game.SpawnVehicle('blista', Luca.SpawnVeh, Luca.SpawnVehHeading, function(vehicle)
        print(DoesEntityExist(vehicle), 'this code is async!')
        SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
    end)

    print('this code is sync!')
end

-- Delivery anim function
local function deliveryAnim()
    local animDict = ''
end



-- ShowBlips for delivery locs
local function ShowBlipsAndLoc(bool)
    if bool then
        for k, v in pairs(Luca.DeliveryLoc) do
            local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
            SetBlipSprite(blip, 20)
            SetBlipColour(blip, 0)
            SetBlipScale(blip, 1.0)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('PostNL - Afleveren')
            EndTextCommandSetBlipName(blip)
        end
        lib.notify({
            title = 'Indienst',
            description = 'Ga naar de afleverpunten op de map.',
            type = 'info'
        })
    end
end

-- Main context menu
lib.registerContext({
    id = 'main',
    title = 'PostNL',
    options = {
        {
            title = 'Start dienst',
            description = 'Start je PostNL job',
            icon = 'truck-fast',
            onSelect = function()
                inDienst = true
                spawnVeh()
                ShowBlipsAndLoc(true)
            end
        },
        {
            title = 'Stop dienst',
            icon = 'stop',
            onSelect = function()
                if inDienst == true then
                    inDienst = false
                else
                    lib.notify({
                        title = 'Indienst',
                        description = 'Je bent niet indienst.',
                        type = 'error'
                    })
                end
            end
        }
    }
})


-- Spawn ped for starting job
CreateThread(function()
    local playerCoords = GetEntityCoords(PlayerPedId())
    if #(playerCoords - Luca.Kleedkamer) < 3.0 then
        if not IsModelValid(Luca.PedModel) then return end

        local ped
        RequestModel(joaat(Luca.PedModel))
        while not HasModelLoaded(joaat(Luca.PedModel)) do
            Wait(5)
        end
        ped = CreatePed(4, Luca.PedModel, Luca.Kleedkamer.x, Luca.Kleedkamer.y,
            Luca.Kleedkamer.z, Luca.KleedkamerHeading, false,
            false)
        SetEntityNoCollisionEntity(PlayerPedId(), ped, false)
        SetEntityCanBeDamaged(ped, false)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        exports.ox_target:addLocalEntity(ped, {
            {
                label = 'Inklokken',
                icon = 'boxes-stacked',
                distance = 3.0,
                onSelect = function()
                    lib.showContext('main')
                end
            }
        })
    end
end)



-- Handle delivering the package
CreateThread(function()
    while true do
        local sleep = 1000
        local playerCoords = GetEntityCoords(PlayerPedId())
        for k, v in pairs(Luca.DeliveryLoc) do
            if #(playerCoords - v.coords) < 2.5 and inDienst == true and not Luca.DeliveryLoc.isDelivered then
                sleep = 0
                DrawMarker(2, v.coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 52, 64, 235, 222, true, false, 2, true,
                    nil, nil, false)

                lib.showTextUI('[E] - Lever Pakket ', { position = "top-center" })




                if IsControlJustReleased(0, 38) then -- E key
                    lib.progressCircle({
                        label = 'Pakket afleveren',
                        duration = 3000,
                        position = 'bottom',
                        useWhileDead = false,
                        canCancel = true,
                        disable = {
                            car = true,
                        },
                        anim = {
                            dict = 'amb@prop_human_parking_meter@male@idle_a',
                            clip = 'idle_a'
                        },
                    })
                    if inDienst == true and not Luca.DeliveryLoc.isDelivered then
                        TriggerServerEvent('deliveryReward', inDienst)
                        return true
                    else
                        print('hacker')
                        return false
                    end
                end
            else
                lib.hideTextUI()
            end

            Wait(sleep)
        end
    end
end)
