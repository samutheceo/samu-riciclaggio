ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('TaticalGamemode:RiciclaDenaro')
AddEventHandler('TaticalGamemode:RiciclaDenaro', function(dirty_money, clean_money, fee)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then 
        local blackMoney = xPlayer.getAccount('black_money').money

        if blackMoney >= dirty_money then
            xPlayer.removeInventoryItem('black_money', dirty_money)
            xPlayer.removeInventoryItem('money', fee)
            xPlayer.addInventoryItem('money', clean_money)

            TriggerClientEvent('esx:showNotification', source, 'Hai pulito ' .. dirty_money .. ' soldi sporchi e ricevuto ' .. clean_money .. ' soldi puliti.')
            TriggerEvent('TaticalGamemode:PuliziaSoldiChiudi')
        else
            TriggerClientEvent('esx:showNotification', source, 'Non hai abbastanza soldi sporchi.')
            TriggerEvent('TaticalGamemode:PuliziaSoldiChiudi')
        end
    end
end)