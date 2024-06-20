--import/locals ⭐
ESX = exports['es_extended']:getSharedObject()
local isVisible = false
----ped♟️
    pedsoldi = {
        [1] = {
            coords = TaticalGamemode_PuliziaSoldi.NPCs.coords,
        },
    }

    exports.ox_target:addBoxZone({
        coords = vec3(TaticalGamemode_PuliziaSoldi.Target.coords),
        size = vec3(2,2,2),
        rotation = 45,
        options = {
            {
                name="stazione_pulizia_soldi",
                event = "TaticalGamemode:PuliziaSoldiApri",
                icon = TaticalGamemode_PuliziaSoldi.Target.icona,
                label = TaticalGamemode_PuliziaSoldi.Target.label,
            }
        },
    })



--comandi 🖐️
RegisterCommand('puliscimoney', function()
    SetNuiFocus(1, 1)
    SendNUIMessage({
        action = 'showRiciclaggio'
    })
end, false)



--🎭 Callback 🎭
RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'hideRiciclaggio'
    })
    cb('ok')
end)

RegisterNUICallback('cleanMoney', function(data, cb)
    local dati_riciclaggio = {
        clean_money = data[1],
        dirty_money = data[2],
        fee = data[3] --la fee sarebbe ls commisione in piu' da pagare (del 30%) --"samu
    }
    
    local dirty_money = tonumber(dati_riciclaggio.dirty_money)
    local clean_money = tonumber(dati_riciclaggio.clean_money)
    local fee = tonumber(dati_riciclaggio.fee)
    
    if dirty_money and dirty_money <= 1 then
        SetNuiFocus(false, false)
        SendNUIMessage({
            action = 'hideRiciclaggio'
        })
        ESX.ShowNotification('Inserisci una quantità valida')
        cb('ok')
        return
    end
    
    if dirty_money and dirty_money >= 50 then
        TriggerServerEvent('TaticalGamemode:RiciclaDenaro', dirty_money, clean_money, fee)
    else
        SetNuiFocus(false, false)
        SendNUIMessage({
            action = 'hideRiciclaggio'
        })
        ESX.ShowNotification('Il minimo da pulire è $50')
    end
    
    cb('ok')
end)



--Events 🗽
RegisterNetEvent('TaticalGamemode:PuliziaSoldiApri')
AddEventHandler('TaticalGamemode:PuliziaSoldiApri', function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'showRiciclaggio'
    })
end)

RegisterNetEvent('TaticalGamemode:PuliziaSoldiChiudi')
AddEventHandler('TaticalGamemode:PuliziaSoldiChiudi', function()
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'hideRiciclaggio'
    })
end)


--Cicli 🚀
Citizen.CreateThread(function()
    for k, v in pairs(pedsoldi) do 
        local ped_hash = GetHashKey(TaticalGamemode_PuliziaSoldi.NPCs.Modello_Ped)
        RequestModel(ped_hash)
        while not HasModelLoaded(ped_hash) do
            Citizen.Wait(1)
        end	
        SoldiSporchiped = CreatePed(1, ped_hash, v.coords, 91.17, false, true)
        SetBlockingOfNonTemporaryEvents(SoldiSporchiped, true)
        SetPedDiesWhenInjured(SoldiSporchiped, false)
        SetPedCanPlayAmbientAnims(SoldiSporchiped, true)
        SetPedCanRagdollFromPlayerImpact(SoldiSporchiped, false)
        SetEntityInvincible(SoldiSporchiped, true)
        FreezeEntityPosition(SoldiSporchiped, true)
        TaskPlayAnim(SoldiSporchiped, "amb@world_human_smoking@male@male_a@enter", "enter", 8.0, -8.0, -1, 0, 0, false, false, false)
    end
end)