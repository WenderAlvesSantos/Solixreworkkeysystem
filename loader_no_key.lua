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

-- Carregar bootstrapper primeiro (se existir)
if readfile and isfile(bootstrapper_path) then
    print("📦 Carregando bootstrapper Luarmor...")
    local bootstrapper_content = readfile(bootstrapper_path)
    if bootstrapper_content and #bootstrapper_content > 0 then
        local boot_success, boot_err = pcall(function()
            loadstring(bootstrapper_content)()
        end)
        if boot_success then
            print("✅ Bootstrapper carregado")
        else
            warn("⚠️ Bootstrapper falhou (pode não ser necessário):", boot_err)
        end
    end
end

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
