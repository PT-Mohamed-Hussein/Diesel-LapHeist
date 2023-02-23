
function CanCarryItem (src, item, amount)
    local Player = QBCore.Functions.GetPlayer(src)
    local totalWeight = QBCore.Player.GetTotalWeight(Player.PlayerData.items)
    local itemInfo = QBCore.Shared.Items[item:lower()]
    if not itemInfo then
		TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, 'Item Not Exist', 'error')
        return false
    end
    amount = tonumber(amount)
    if (totalWeight + (itemInfo['weight'] * amount)) <= Config.MaxInventoryWeight then
        return true
    else
        return false
    end
end

