Config = {}
--OPEN HERE FOR ITEMS https://finalz-scripts.gitbook.io/docs/finalz-free/finalz-fishing/items
--https://finalz-scripts.gitbook.io/docs/finalz-free/finalz-fishing/items
Config.MinigameSettings = {
    difficulty = "hard" -- https://overextended.dev/ox_lib/Modules/Interface/Client/skillcheck
}
Config.MinigameKeys = {
    [0] = 'w',
    [1] = 'a',
    [2] = 's',
    [3] = 'd',
}

RegisterNetEvent("notify")
AddEventHandler("notify", function(msg, type, time)
    lib.notify({
        title = 'FinalZ Fishing',
        description = msg,
        type = type,
        duration = time
    })
end)

Config.buyers = {
    {
        coords = vector3(-1815.0890, -1193.2690, 14.3048),
        heading = 68.1731,
        model = "a_m_y_business_02",
        label = "FinalZ fishy",
        blip = {
            label = "FinalZ fishy",
            color = 3,
            scale = 0.8,
            sprite = 371
        }
    }
}
Config.FeedingTime  = 2 -- minutes
Config.Fishes = {  -- dont add new categories!  
    ['normal'] = {
        [0] = { fish = 'fishing_carp', price = 100 },         -- Ponty
        [1] = { fish = 'fishing_buffalo', price = 100 },      -- Bivalyhal
        [2] = { fish = 'fishing_bream', price = 100 },        -- Keszeg
        [3] = { fish = 'fishing_white_bass', price = 100 },   -- Fehér sügér
        [4] = { fish = 'fishing_yellow_perch', price = 100 }, -- Sárga sügér
        [5] = { fish = 'fishing_pike', price = 100 },         -- Csuka
        [6] = { fish = 'fishing_cod', price = 100 },          -- Tőkehal
        [7] = { fish = 'fishing_walleye', price = 100 },      -- Süllő
        [8] = { fish = 'fishing_salmon', price = 100 },       -- Lazac
        [9] = { fish = 'fishing_pufferfish', price = 100 },   -- Gömbhal
        [10] = { fish = 'fishing_sturgeon', price = 100 },    -- Sávos vörösmárna
        [11] = { fish = 'fishing_suremullet', price = 100 },  -- Tokhal
        [12] = { fish = 'fishing_trout', price = 100 },       -- Pisztráng
    },
    ['rare'] = {
        [1] = { fish = 'fishing_buffalo', price = 200 },      -- Bivalyhal
        [2] = { fish = 'fishing_bream', price = 200 },        -- Keszeg
        [3] = { fish = 'fishing_white_bass', price = 200 },   -- Fehér sügér
        [4] = { fish = 'fishing_yellow_perch', price = 200 }, -- Sárga sügér
        [5] = { fish = 'fishing_pike', price = 200 },         -- Csuka
        [6] = { fish = 'fishing_cod', price = 200 },          -- Tőkehal
        [7] = { fish = 'fishing_walleye', price = 200 },      -- Süllő
        [8] = { fish = 'fishing_salmon', price = 200 },       -- Lazac
        [9] = { fish = 'fishing_pufferfish', price = 200 },   -- Gömbhal
        [10] = { fish = 'fishing_sturgeon', price = 200 },    -- Sávos vörösmárna
        [11] = { fish = 'fishing_suremullet', price = 200 },  -- Tokhal
        [12] = { fish = 'fishing_trout', price = 200 },       -- Pisztráng
        [13] = { fish = 'fishing_tigershark', price = 200 },  -- Cápa
        [14] = { fish = 'fishing_turtle', price = 200 },      -- Teknős
        [15] = { fish = 'fishing_swordfish', price = 200 },   -- Kardhal
    }
}

Config.Locale = "EN"
Config.Locales = {
    ["EN"] = {
        TargetLabel = "Sell fishes",
        SwimminFeed = "You cannot feed while swimming!",
        vehicleFeed = "You cannot feed from a vehicle!",
        SwimminCatch = "You cant start fishing while swimming!",
        vehicleCatch = "You cannot start fishing from vehicle!",
        noFishFood = "You have no fish food!",
        alreadyFeed = "You have already fed once, wait until it runs out!",
        noWater = "There is no water nearby!",
        failedCatch = "Unfortunately, you messed up hooking the bait, so it crumbled.",
        fishCatched = "You caught a fish: ",
        fishCatchedGarbage = "Unfortunately, you caught some garbage.",
        feedingZone = "Feeding zone",
        feedingEffect = " minutes left of the feeding effect",
        feedingEffectEnded = "The feeding effect has ended!",
        CantCarry = "You can't carry more items!"
    },
    ["HU"] = {
        TargetLabel = "Hal eladás",
        SwimminFeed = "Úszás közben nem tudsz etetni!",
        vehicleFeed = "Járműből nem tudsz etetni!",
        SwimminCatch = "Úszás közben nem tudsz horgászni!",
        vehicleCatch = "Járműből nem tudsz horgászni!",
        noFishFood = "Nincs nálad haltáp!",
        alreadyFeed = "Már etettél egyszer, várd meg míg az elfogy!",
        noWater = "Nincs víz a közeledben!",
        failedCatch = "Sajna elrontottad a csali horogra akasztását, így szétmorzsolódott a csali.",
        fishCatched = "Kifogtál egy halat: ",
        fishCatchedGarbage = "Sajnos egy szemetet fogtál ki.",
        feedingZone = "Etetőanyag zóna",
        feedingEffect = " perc van hátra az etetőanyag hatásából",
        feedingEffectEnded = "Az etetőanyag hatása véget ért!",
        CantCarry = "Nem fér el nálad több!"
    }
}
