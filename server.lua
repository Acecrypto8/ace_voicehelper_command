local QBCore = nil
local usingQBCore = false
local cmd = Config.cmdName or "givevoicehelper"
local frameWork = Config.frameWork

CreateThread(function()
    Wait(500)
    if GetResourceState('qb-core') == 'started' and frameWork == 'qb' then
        QBCore = exports['qb-core']:GetCoreObject()
        usingQBCore = true
        print('[VoiceHelper] QBCore detected. Using QBCore permissions.')
    else
        print('[VoiceHelper] QBCore not found. Using Config.Admins fallback.')
    end
end)

RegisterCommand(cmd, function(source, args)
    local src = source
    local targetId = tonumber(args[1])

    if not targetId then
        TriggerClientEvent("chat:addMessage", src, {
            args = { "^1Usage:", "/givevoicehelper [player ID]" }
        })
        return
    end

    if usingQBCore then
        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then return end

        local permission = QBCore.Functions.GetPermission(src)
        if permission.god or permission.admin or permission.mod then
            TriggerClientEvent("voicehelper:startCheck", targetId)
        else
            TriggerClientEvent("chat:addMessage", src, {
                args = { "^1Error:", "You don't have permission to use this command." }
            })
        end
    else
        local license = GetPlayerLicense(src)
        if Config.Admins[license] then
            TriggerClientEvent("voicehelper:startCheck", targetId)
        else
            TriggerClientEvent("chat:addMessage", src, {
                args = { "^1Error:", "You are not authorized to use this command." }
            })
        end
    end
end, false)

function GetPlayerLicense(src)
    local identifiers = GetPlayerIdentifiers(src)
    for _, id in ipairs(identifiers) do
        if string.sub(id, 1, 7) == "license" then
            return id
        end
    end
    return nil
end
