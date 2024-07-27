local peds = {}
local nametags = {}
local blips = {}
local feedingzone = false
local isinfeedingzone = false

local keys = Config.MinigameKeys

local rewards = Config.Fishes

local buyers = Config.buyers

local itemNames = {}

function SetNuiState(state)
    SetNuiFocus(state, state)
    SendNUIMessage({
        type = "show",
        enable = state,
    })
end

RegisterNUICallback('exit', function(data, cb)
    SetNuiState(false)
    cb('ok')
end)


for item, data in pairs(exports.ox_inventory:Items()) do
    if item:match("fishing_") then
        itemNames[item] = data.label
    end
end

function ShowSubtitle(Message, Duration)
    BeginTextCommandPrint('STRING')
    AddTextComponentString(Message)
    EndTextCommandPrint(Duration, true)
end

function IsFacingWater()
    local headPos = GetPedBoneCoords(cache.ped, 31086, 0.0, 0.0, 0.0)
    local offsetPos = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 50.0, -25.0)
    local hit, hitPos = TestProbeAgainstWater(headPos.x, headPos.y, headPos.z, offsetPos.x, offsetPos.y, offsetPos.z)
    return hit, hitPos
end

function StartFeeding()
    local NearWater, _ = IsFacingWater()
    if NearWater and not cache.vehicle and not IsPedSwimming(cache.ped) and exports.ox_inventory:GetItemCount("fish_food") > 0 and not feedingzone then
        ClearPedSecondaryTask(cache.ped)
        FreezeEntityPosition(cache.ped, true)
        LocalPlayer.state.invBusy = true
        LocalPlayer.state.invHotkeys = false
        exports.ox_target:disableTargeting(true)
        DisablePlayerFiring(cache.playerId, true)
        TriggerEvent('ox_inventory:disarm', cache.playerId, false)
        local geeky = CreateObject(GetHashKey("prop_food_bs_bag_04"), 0, 0, 0, true, true, true)
        AttachEntityToEntity(geeky, cache.ped, GetPedBoneIndex(cache.ped, 28422), 0.12, 0.0, 0.00, 25.0, 270.0, 180.0,
            true, true, false, true, 1, true)
        lib.requestAnimDict("anim@heists@narcotics@trash")
        TaskPlayAnim(cache.ped, 'anim@heists@narcotics@trash', 'throw_b', 1.0, -1.0, 1.0, 48, 0, 0, 0, 0)
        Wait(1500)

        sphere = lib.zones.sphere({
            coords = vec3(GetEntityCoords(cache.ped).x, GetEntityCoords(cache.ped).y, GetEntityCoords(cache.ped).z),
            radius = 15.0,
            debug = true,
            inside = function()
                if not isinfeedingzone then
                    isinfeedingzone = true
                end
            end,
            onEnter = function()
                isinfeedingzone = true
            end,
            onExit = function()
                isinfeedingzone = false
            end
        })
        feedingzone = true

        local blip = AddBlipForCoord(GetEntityCoords(cache.ped).x, GetEntityCoords(cache.ped).y,
            GetEntityCoords(cache.ped).z)
        SetBlipColour(blip, 15)
        SetBlipAsShortRange(blip, true)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipSprite(blip, 304)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Locales[Config.Locale].feedingZone)
        EndTextCommandSetBlipName(blip)

        local blipzone = AddBlipForRadius(GetEntityCoords(cache.ped).x, GetEntityCoords(cache.ped).y,
            GetEntityCoords(cache.ped).z, 15.0)
        SetBlipColour(blipzone, 12)
        SetBlipAlpha(blipzone, 120)
        SetBlipAsShortRange(blipzone, true)

        ClearPedTasks(cache.ped)
        DeleteObject(geeky)
        RemoveAnimDict('anim@heists@narcotics@trash')
        FreezeEntityPosition(cache.ped, false)
        LocalPlayer.state.invBusy = false
        LocalPlayer.state.invHotkeys = true
        exports.ox_target:disableTargeting(false)
        DisablePlayerFiring(cache.playerId, false)

        SetTimeout(10, function()
            for i = Config.FeedingTime, 1, -1 do
                ShowSubtitle(i .. Config.Locales[Config.Locale].feedingEffect, Config.FeedingTime * 60000)
                print(i)
                Wait(Config.FeedingTime * 60000)
                if i <= 1 then
                    sphere:remove()
                    RemoveBlip(blip)
                    RemoveBlip(blipzone)
                    feedingzone = false
                    ShowSubtitle(Config.Locales[Config.Locale].feedingEffectEnded, 5000)
                    break
                end
            end
        end)
        print("As")
    elseif IsPedSwimming(cache.ped) then
        TriggerEvent('notify', Config.Locales[Config.Locale].SwimminFeed, 'info', 5000)
    elseif cache.vehicle then
        TriggerEvent('notify', Config.Locales[Config.Locale].vehicleFeed, 'info', 5000)
    elseif exports.ox_inventory:GetItemCount("fish_food") == 0 then
        TriggerEvent('notify', Config.Locales[Config.Locale].noFishFood, 'info', 5000)
    elseif feedingzone then
        TriggerEvent('notify', Config.Locales[Config.Locale].alreadyFeed, 'info', 5000)
    else
        TriggerEvent('notify', Config.Locales[Config.Locale].noWater, 'info', 5000)
    end
end

function StartFishing()
    local NearWater, _ = IsFacingWater()
    local retval --[[ boolean ]], groundZ --[[ number ]] =
        GetGroundZFor_3dCoord(GetEntityCoords(cache.ped).x, GetEntityCoords(cache.ped).y, GetEntityCoords(cache.ped).z,
            false)

    print(retval, groundZ)
    local waterDepth = groundZ * -1

    if NearWater and not cache.vehicle and not IsPedSwimming(cache.ped) then
        if exports.ox_inventory:GetItemCount("bait") > 0 then
            -- "mp_missheist_countrybank@nervous" "idle_c"

            ClearPedSecondaryTask(cache.ped)
            FreezeEntityPosition(cache.ped, true)
            LocalPlayer.state.invBusy = true
            LocalPlayer.state.invHotkeys = false
            exports.ox_target:disableTargeting(true)
            DisablePlayerFiring(cache.playerId, true)
            TriggerEvent('ox_inventory:disarm', cache.playerId, false)
            lib.requestAnimDict("mp_missheist_countrybank@nervous")
            TaskPlayAnim(cache.ped, "mp_missheist_countrybank@nervous", 'nervous_idle', 1.0, -1.0, 1.0, 48, 0, 0, 0, 0)
            local HookedBait = lib.skillCheck({ { areaSize = 60, speedMultiplier = 1.0 } }, { keys[math.random(#keys)] })
            if HookedBait then
                goto continue
            else
                lib.callback('Z_Fishing:server:ManageItem', false, function()
                    TriggerEvent('notify', Config.Locales[Config.Locale].failedCatch, 'info', 5000)
                    ClearPedTasks(cache.ped)
                    DeleteEntity(fishprop)
                    FreezeEntityPosition(cache.ped, false)
                    LocalPlayer.state.invBusy = false
                    LocalPlayer.state.invHotkeys = true
                    exports.ox_target:disableTargeting(false)
                    DisablePlayerFiring(cache.playerId, false)
                end, false, "bait", 1)
                return
            end
            ::continue::
            lib.callback('Z_Fishing:server:ManageItem', false, function() end, false, "bait", 1)
            local model = `prop_fishing_rod_01`
            lib.requestModel(model, 100)
            pole = CreateObject(model, GetEntityCoords(cache.ped), true, false, false)
            AttachEntityToEntity(pole, cache.ped, GetPedBoneIndex(cache.ped, 18905), 0.1, 0.05, 0, 80.0, 120.0, 160.0,
                true, true, false, true, 1, true)
            SetModelAsNoLongerNeeded(model)
            lib.requestAnimDict('anim@arena@celeb@flat@paired@no_props@', 100)
            lib.requestAnimDict('amb@world_human_stand_fishing@idle_a', 100)
            lib.requestAnimDict('random@domestic', 100)
            TaskPlayAnim(cache.ped, 'anim@arena@celeb@flat@paired@no_props@', 'baseball_a_player_a', 1.0, -1.0, 1.0, 48,
                0, 0, 0, 0)
            Wait(4000)
            TaskPlayAnim(cache.ped, 'amb@world_human_stand_fishing@idle_a', 'idle_c', 1.0, -1.0, 1.0, 11, 0, 0, 0, 0)

            Wait(math.random(2000, 5000))

            local Catchedfish = lib.skillCheck({Config.MinigameSettings.difficulty},
                { keys[math.random(#keys)] })

            if Catchedfish then
                if feedingzone then
                    function sphere:inside()
                        if not isinfeedingzone then
                            isinfeedingzone = true
                        end
                    end
                end
                if waterDepth >= 70.0 then
                    print("Melyvizben horgasztal")
                    local fish = math.random(#rewards['rare'])
                    -- lib.print.info(fish, "szamu hal")
                    -- lib.print.info("You got a: " .. rewards[fish].fish)
                    if isinfeedingzone then
                        lib.callback('Z_Fishing:server:ManageItem', false, function()
                            TriggerEvent('notify', Config.Locales[Config.Locale].fishCatched .. itemNames[rewards['rare'][fish].fish] .. ".",
                                'info', 5000)
                        end, true, rewards['rare'][fish].fish, math.random(1, 3))
                    else
                        lib.callback('Z_Fishing:server:ManageItem', false, function()
                            TriggerEvent('notify',
                                Config.Locales[Config.Locale].fishCatched .. itemNames[rewards['rare'][fish].fish] .. ".",
                                'info', 5000)
                        end, true, rewards['rare'][fish].fish, 1)
                    end
                else
                    local fish = math.random(#rewards['normal'])
                    -- lib.print.info(fish, "szamu hal")
                    -- lib.print.info("You got a: " .. rewards[fish].fish)
                    if isinfeedingzone then
                        lib.callback('Z_Fishing:server:ManageItem', false, function()
                            TriggerEvent(
                                Config.Locales[Config.Locale].fishCatched ..
                                itemNames[rewards['normal'][fish].fish] .. ".",
                                'info', 5000)
                        end, true, rewards['normal'][fish].fish, math.random(1, 4))
                    else
                        lib.callback('Z_Fishing:server:ManageItem', false, function()
                            TriggerEvent(
                                Config.Locales[Config.Locale].fishCatched ..
                                itemNames[rewards['normal'][fish].fish] .. ".",
                                'info', 5000)
                        end, true, rewards['normal'][fish].fish, 1)
                    end
                end
            else
                local chance = math.random(100)
                if chance < 50 then
                    lib.callback('Z_Fishing:server:ManageItem', false, function()
                        TriggerEvent('notify', Config.fishCatchedGarbage, 'info', 5000)
                    end, true, 'garbage', 1)
                    -- lib.print.info("You got a piece of trash")
                end
            end

            ClearPedTasks(cache.ped)
            DeleteObject(pole)
            RemoveAnimDict('mp_missheist_countrybank@nervous')
            RemoveAnimDict('anim@arena@celeb@flat@paired@no_props@')
            RemoveAnimDict('amb@world_human_stand_fishing@idle_a')

            lib.requestModel("a_c_fish")
            local fishpropmodel = `a_c_fish`
            local fishprop = CreatePed(1, fishpropmodel, GetEntityCoords(cache.ped), 124.0, true, false)
            AttachEntityToEntity(fishprop, cache.ped, GetPedBoneIndex(cache.ped, 28422), 0.1, 0.05, 0, 80.0, 120.0, 160.0,
                true, true, false, true, 1, true)
            TaskPlayAnim(cache.ped, 'random@domestic', 'pickup_low', 1.0, -1.0, 1.0, 11, 0, 0, 0, 0)
            Wait(1500)
            ClearPedTasks(cache.ped)
            DeleteEntity(fishprop)
            FreezeEntityPosition(cache.ped, false)
            LocalPlayer.state.invBusy = false
            LocalPlayer.state.invHotkeys = true
            exports.ox_target:disableTargeting(false)
            DisablePlayerFiring(cache.playerId, false)
            RemoveAnimDict('random@domestic')
        else
            -- lib.print.error('Nem vagy viz közelében')
            TriggerEvent('notify', Config.Locales[Config.Locale].noFishFood, 'info', 5000)
        end
    elseif IsPedSwimming(cache.ped) then
        TriggerEvent('notify', Config.Locales[Config.Locale].SwimminCatch, 'info', 5000)
    elseif cache.vehicle then
        TriggerEvent('notify', Config.Locales[Config.Locale].vehicleCatch, 'info', 5000)
    else
        TriggerEvent('notify', Config.Locales[Config.Locale].noWater, 'info', 5000)
    end
    -- lib.print.warn('Function ran successfully')
end

function openMenu()
    lib.callback('Z_Fishing:server:GetFishItems', false, function(fishItems)
        if #fishItems == 0 then
            TriggerEvent('notify', Config.Locales[Config.Locale].noFishItems, 'error', 5000)
        else
            SendNUIMessage({
                type = 'showFishItems',
                items = fishItems
            })
            SetNuiState(true)
        end
    end)
end

RegisterNUICallback('sellFish', function(data, cb)
    lib.callback('Z_Fishing:server:SellFish', false, function(response)
        if response.success then
            lib.callback('Z_Fishing:server:GetFishItems', false, function(fishItems)
                SendNUIMessage({
                    type = 'showFishItems',
                    items = fishItems
                })
            end)
        end
        cb(response)
    end, data.fish, data.count)
end)


---@param type boolean
function ManageSellerNPC(type)
    lib.requestModel("a_m_y_business_02")
    if type then
        for k, v in pairs(buyers) do
            local ped = CreatePed(1, v.model, v.coords.x, v.coords.y, v.coords.z - 1.0, v.heading, false, false)
            peds[#peds + 1] = ped
            FreezeEntityPosition(peds[k], true)
            SetBlockingOfNonTemporaryEvents(peds[k], true)
            SetEntityInvincible(peds[k], true)
            TaskStartScenarioInPlace(peds[k], "WORLD_HUMAN_CLIPBOARD", -1, false)
            local label = CreateMpGamerTag(peds[k], v.label, false, false, "", 0)
            SetMpGamerTagsVisibleDistance(15.0)
            nametags[#nametags + 1] = label
            exports.ox_target:addLocalEntity(peds, {
                {
                    label = Config.Locales[Config.Locale].TargetLabel,
                    name = "SellMenu",
                    icon = "fa-solid fa-fish-fins",
                    distance = 1.5,
                    onSelect = function()
                        openMenu()
                    end,
                },
            })

            local blip = AddBlipForCoord(v.coords.xyz)
            blips[#blips + 1] = blip
            SetBlipSprite(blips[k], v.blip.sprite)
            SetBlipColour(blips[k], v.blip.color)
            SetBlipDisplay(blips[k], 4)
            SetBlipAsShortRange(blips[k], true)
            SetBlipScale(blips[k], v.blip.scale)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.blip.label)
            EndTextCommandSetBlipName(blips[k])
        end
    else
        peds = {}
        for k, v in pairs(nametags) do
            print(k, v)
            RemoveMpGamerTag(v)
        end
    end
end

RegisterNetEvent('Z_Fishing:client:ConfirmSell')
AddEventHandler('Z_Fishing:client:ConfirmSell', function(success, fishItems)
    if success then
        SendNUIMessage({
            type = 'showFishItems',
            items = fishItems
        })
    else
        TriggerEvent('notify', "Nem tudod eladni a halakat!", 'info', 5000)
    end
end)

CreateThread(function()
    ManageSellerNPC(true)
end)

AddEventHandler("onResourceStop", function(resname)
    if (resname ~= GetCurrentResourceName()) then return end

    ManageSellerNPC(false)
end)

exports('StartFishing', StartFishing)
exports('StartFeeding', StartFeeding)
