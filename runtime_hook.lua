-- ============================================================
-- HOOK RUNTIME PARA CAPTURAR INFORMAÇÕES DO SCRIPT OFUSCADO
-- Executa o script e captura strings, funções e chamadas importantes
-- ============================================================

repeat wait() until game:IsLoaded()

print("=" .. string.rep("=", 60))
print("🔍 RUNTIME HOOK - Capturando informações do script")
print("=" .. string.rep("=", 60))

local captured_data = {
    strings = {},
    functions = {},
    calls = {},
    kicks = {}
}

-- Hook em print/warn para capturar mensagens
local original_print = print
local original_warn = warn

print = function(...)
    local args = {...}
    local msg = table.concat(args, " ")
    table.insert(captured_data.strings, "PRINT: " .. msg)
    return original_print(...)
end

warn = function(...)
    local args = {...}
    local msg = table.concat(args, " ")
    table.insert(captured_data.strings, "WARN: " .. msg)
    return original_warn(...)
end

-- Hook em player:Kick para capturar tentativas
local Players = game:GetService("Players")
if Players and Players.LocalPlayer then
    local player = Players.LocalPlayer
    if getrawmetatable then
        local mt = getrawmetatable(player)
        if mt then
            if setreadonly then setreadonly(mt, false) end
            local originalIndex = mt.__index
            mt.__index = function(self, key)
                if key == "Kick" then
                    return function(reason)
                        table.insert(captured_data.kicks, {
                            reason = tostring(reason or ""),
                            time = os.time()
                        })
                        warn("🚨 KICK CAPTURADO:", reason)
                        -- Não bloquear, apenas capturar
                        return originalIndex(self, key)(reason)
                    end
                end
                return originalIndex(self, key)
            end
            if setreadonly then setreadonly(mt, true) end
        end
    end
end

-- Carregar e executar script
local script_path = "captured_e2718ddebf562c5c4080dfce26b09398_1768452204.lua"

if readfile and isfile(script_path) then
    print("📂 Carregando script...")
    local script_content = readfile(script_path)
    
    if script_content and #script_content > 0 then
        print("🚀 Executando script com hooks ativos...")
        
        local success, err = pcall(function()
            loadstring(script_content)()
        end)
        
        if not success then
            warn("❌ Erro:", err)
        end
        
        -- Salvar dados capturados
        wait(2) -- Esperar um pouco para capturar mais dados
        
        if writefile then
            local report = "-- RUNTIME HOOK REPORT\n"
            report = report .. "-- Gerado em: " .. os.date() .. "\n\n"
            
            report = report .. "-- STRINGS CAPTURADAS (" .. #captured_data.strings .. "):\n"
            for i, str in ipairs(captured_data.strings) do
                report = report .. "-- " .. i .. ". " .. str .. "\n"
            end
            
            report = report .. "\n-- KICKS CAPTURADOS (" .. #captured_data.kicks .. "):\n"
            for i, kick in ipairs(captured_data.kicks) do
                report = report .. "-- " .. i .. ". Motivo: " .. kick.reason .. " (Time: " .. kick.time .. ")\n"
            end
            
            local report_path = "runtime_hook_report_" .. os.time() .. ".txt"
            writefile(report_path, report)
            print("💾 Relatório salvo em:", report_path)
        end
    end
else
    warn("❌ Arquivo não encontrado:", script_path)
end

