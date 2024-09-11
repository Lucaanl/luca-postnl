Luca = {}

Luca.Job = 'postnl'                                    -- Job name registered in database
Luca.Kleedkamer = vec3(-1156.3837, -1569.0294, 4.4282) -- Coords to start job at
Luca.KleedkamerHeading = 308.9198                      -- Heading ^^
Luca.PedModel = 'a_f_m_bevhills_01'                    -- Ped model whom you interact with to start job
Luca.SpawnVehModel = 'blista'                          -- Model of vehicle to spawn when starting job
Luca.SpawnVeh = vec3(-1185.7279, -1493.1019, 4.3724)   -- Coords to spawn vehicle at when starting job
Luca.SpawnVehHeading = 126.5465                        -- Heading ^^


Luca.Item, Luca.ItemCount = 'money',
    750                                                                    -- Item and count to give when delivering a package

Luca.DeliveryLoc = {                                                       -- All the delivery locations, add as many as you want (xyz)
    { coords = vec3(-1313.4431, -1527.8041, 4.4164), isDelivered = false } -- Only touch the coords value
}
