-- ============================================================
-- LOADER SEM PROTEÇÃO DE KEY
-- Carrega o script capturado diretamente sem passar pelo sistema Luarmor
-- ============================================================

repeat wait() until game:IsLoaded()

local cloneref = cloneref or function(o) return o end
local wait = task.wait

print("=" .. string.rep("=", 60))
print("🔓 LOADER SEM PROTEÇÃO DE KEY")
print("=" .. string.rep("=", 60))

-- ===================== BYPASS DE VERIFICAÇÕES =====================
-- Criar ambiente simulado do Luarmor para evitar detecção
local function setup_bypass()
    -- Interceptar possíveis verificações de key
    if not _G._luarmor_bypass_setup then
        _G._luarmor_bypass_setup = true
        
        -- Criar tabela de bypass para verificações comuns
        local bypass_table = {
            check_key = function() 
                return {code = "KEY_VALID", data = {auth_expire = os.time() + 999999999}} 
            end,
            load_script = function() end,
            script_id = "e2718ddebf562c5c4080dfce26b09398",
            verify = function() return true end,
            validate = function() return true end
        }
        
        -- Tentar injetar no ambiente global
        if _G then
            for k, v in pairs(bypass_table) do
                if not _G[k] then
                    _G[k] = v
                end
            end
        end
        
        -- Interceptar possíveis chamadas de kick/ban usando metatable
        local Players = game:GetService("Players")
        if Players and Players.LocalPlayer then
            local player = Players.LocalPlayer
            local mt = getrawmetatable(player)
            if mt then
                local originalIndex = mt.__index
                mt.__index = function(self, key)
                    if key == "Kick" then
                        return function(reason)
                            if reason and (
                                string.find(tostring(reason), "key", 1, true) or
                                string.find(tostring(reason), "Key", 1, true) or
                                string.find(tostring(reason), "KEY", 1, true) or
                                string.find(tostring(reason), "luarmor", 1, true) or
                                string.find(tostring(reason), "Luarmor", 1, true) or
                                string.find(tostring(reason), "expired", 1, true) or
                                string.find(tostring(reason), "invalid", 1, true)
                            ) then
                                warn("🛡️ Bypass: Tentativa de kick por verificação de key bloqueada")
                                warn("   Motivo original:", reason)
                                return -- Bloquear o kick
                            end
                            -- Permitir outros kicks (anti-cheat, etc)
                            return originalIndex(self, key)(reason)
                        end
                    end
                    return originalIndex(self, key)
                end
            end
        end
    end
end

setup_bypass()
-- ===================== FIM BYPASS =====================

-- Configuração: caminhos dos scripts capturados
local bootstrapper_path = "captured_e2718ddebf562c5c4080dfce26b09398_1768452203.lua"  -- Bootstrapper Luarmor
local script_path = "captured_e2718ddebf562c5c4080dfce26b09398_1768452204.lua"        -- Script principal

-- Função para listar arquivos capturados disponíveis
local function find_captured_scripts()
    if not listfiles then return {} end
    local files = {}
    for _, file in ipairs(listfiles("")) do
        if string.find(file, "captured_") and string.find(file, ".lua") then
            table.insert(files, file)
        end
    end
    return files
end

-- Pular bootstrapper - ele precisa de dependências específicas do Luarmor
-- O script principal deve funcionar sem ele
print("⏭️  Pulando bootstrapper (não necessário para execução direta)")

-- Verificar se o arquivo existe
if readfile and isfile(script_path) then
    print("📂 Carregando script principal:", script_path)
    local script_content = readfile(script_path)
    
    if script_content and #script_content > 0 then
        print("✅ Script encontrado!")
        print("📊 Tamanho:", #script_content, "caracteres")
        print("🚀 Executando...")
        print("-" .. string.rep("-", 58))
        
        -- Executar o script diretamente
        local success, err = pcall(function()
            loadstring(script_content)()
        end)
        
        if not success then
            warn("❌ Erro ao executar script:")
            warn(tostring(err))
            print("💡 Dica: O script pode precisar de desofuscação ou dependências")
        else
            print("✅ Script executado com sucesso!")
            print("=" .. string.rep("=", 60))
            print("💡 Se você foi kickado, pode ser anti-cheat do jogo")
            print("💡 Ou o script pode ter verificações internas que precisam ser removidas")
        end
    else
        warn("❌ Arquivo vazio ou corrompido")
    end
else
    warn("❌ Arquivo não encontrado:", script_path)
    
    -- Tentar encontrar outros arquivos capturados
    local available_files = find_captured_scripts()
    if #available_files > 0 then
        print("📁 Arquivos capturados disponíveis:")
        for i, file in ipairs(available_files) do
            print("  " .. i .. ". " .. file)
        end
        print("💡 Ajuste a variável 'script_path' no código para usar um desses arquivos")
    else
        warn("📋 Nenhum arquivo capturado encontrado na pasta do executor")
        warn("💡 Execute o script de captura primeiro para gerar o arquivo")
    end
end
