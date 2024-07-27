lib.callback.register('Z_Fishing:server:ManageItem', function(source, type, item, count)
    if type then
        if exports.ox_inventory:CanCarryItem(source, item, count) then
            exports.ox_inventory:AddItem(source, item, count)
        else
            TriggerClientEvent("notify", source, Config.Locales[Config.Locale].CantCarry, 'error', 5000)
        end
    else
        exports.ox_inventory:RemoveItem(source, item, count)
        return
    end
end)

lib.callback.register('Z_Fishing:server:GetFishItems', function(source)
    local playerInventory = exports.ox_inventory:GetInventory(source)
    local fishItems = {}

    for _, item in pairs(playerInventory.items) do
        for _, fishType in pairs(Config.Fishes) do
            for _, fish in pairs(fishType) do
                if item.name == fish.fish and not fishItems[item.name] then
                    fishItems[item.name] = { name = item.name, label = item.label, count = item.count, price = fish.price }
                end
            end
        end
    end

    -- Convert the dictionary back to an array
    local fishItemsArray = {}
    for _, fish in pairs(fishItems) do
        table.insert(fishItemsArray, fish)
    end

    return fishItemsArray
end)


lib.callback.register('Z_Fishing:server:SellFish', function(source, fish, count)
    local playerInventory = exports.ox_inventory:GetInventory(source)
    local fishItem = exports.ox_inventory:GetItem(source, fish.name)
    local totalPrice = fish.price * count

    if fishItem and fishItem.count >= count then
        exports.ox_inventory:RemoveItem(source, fish.name, count)
        exports.ox_inventory:AddItem(source, 'money', totalPrice)


        return { success = true }
    else
        TriggerClientEvent('Z_Fishing:client:ConfirmSell', source, false)

        return { success = false, message = 'Not enough fish to sell' }
    end
end)