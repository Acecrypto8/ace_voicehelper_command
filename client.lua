local voiceHelperActive = false
local micWorking = false
local displayTimer = 0
local pushToTalkKey = GetControlInstructionalButton(0, 249, true)
if pushToTalkKey:sub(1,2) == "t_" then
    pushToTalkKey = pushToTalkKey:sub(3)
end




RegisterNetEvent("voicehelper:startCheck")
AddEventHandler("voicehelper:startCheck", function()
    if voiceHelperActive then return end

    voiceHelperActive = true
    micWorking = false
    displayTimer = GetGameTimer()

    CreateThread(function()
        while voiceHelperActive do
            Wait(0)

            if not micWorking and NetworkIsPlayerTalking(PlayerId()) then
                micWorking = true
                displayTimer = GetGameTimer()
            end

            if micWorking then
                DrawCenterText("~g~Microphone is working.~s~\nYour keybind is " .. pushToTalkKey, 0.5, 0.45, 0.8)
                if GetGameTimer() - displayTimer > 3000 then
                    voiceHelperActive = false
                end
            else
                DrawCenterText("~r~Microphone not detected.~s~ Press " .. pushToTalkKey .." to try talking.", 0.5, 0.4, 0.6)
                DrawCenterText("If it's not working: Check your Push-to-Talk keybind Settings:", 0.5, 0.45, 0.6)
                DrawCenterText("you can find it here: ESC > Settings > Key Binds > GTA Online > Push to Talk", 0.5, 0.5, 0.6)
                DrawCenterText("Also check your mic under: ESC > Settings > Voice Chat", 0.5, 0.55, 0.6)
            end
        end
    end)
end)

function DrawCenterText(text, x, y, scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(scale or 0.5, scale or 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextCentre(true)
    SetTextOutline()
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end
