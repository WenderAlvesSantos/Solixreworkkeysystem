-- ============================================================
-- DESOFUSCADOR BÁSICO PARA LURAPH
-- Tenta simplificar código ofuscado com Luraph
-- ============================================================

local function deobfuscate_luraph(script_content)
    print("🔓 Iniciando desofuscação...")
    
    local deobfuscated = script_content
    
    -- 1. Remover comentários de ofuscação
    deobfuscated = deobfuscated:gsub("%-%- This file was protected using Luraph Obfuscator[^\n]*", "")
    
    -- 2. Simplificar números hexadecimais e expressões numéricas complexas
    -- Converter 0x56 para 86, etc.
    deobfuscated = deobfuscated:gsub("0x([%da-fA-F]+)", function(hex)
        return tostring(tonumber(hex, 16))
    end)
    
    -- 3. Simplificar expressões como (T>=0x56) para (T>=86)
    deobfuscated = deobfuscated:gsub("%(0x([%da-fA-F]+)%)", function(hex)
        return "(" .. tostring(tonumber(hex, 16)) .. ")"
    end)
    
    -- 4. Simplificar comparações com 0.0 para 0
    deobfuscated = deobfuscated:gsub("==%s*0%.0", "== 0")
    deobfuscated = deobfuscated:gsub("~=%s*0%.0", "~= 0")
    deobfuscated = deobfuscated:gsub("<=%s*0%.0", "<= 0")
    deobfuscated = deobfuscated:gsub(">=%s*0%.0", ">= 0")
    deobfuscated = deobfuscated:gsub("<%s*0%.0", "< 0")
    deobfuscated = deobfuscated:gsub(">%s*0%.0", "> 0")
    
    -- 5. Simplificar números como 1.0 para 1
    deobfuscated = deobfuscated:gsub("(%d+)%.0([^%d])", "%1%2")
    deobfuscated = deobfuscated:gsub("(%d+)%.0$", "%1")
    
    -- 6. Remover espaços desnecessários
    deobfuscated = deobfuscated:gsub("%s+", " ")
    
    print("✅ Desofuscação básica concluída")
    
    return deobfuscated
end

-- Carregar script ofuscado
local script_path = "captured_e2718ddebf562c5c4080dfce26b09398_1768452204.lua"
local output_path = "deobfuscated_" .. script_path

if readfile and isfile(script_path) then
    print("📂 Carregando script ofuscado...")
    local script_content = readfile(script_path)
    
    if script_content and #script_content > 0 then
        print("📊 Tamanho original:", #script_content, "caracteres")
        
        -- Desofuscar
        local deobfuscated = deobfuscate_luraph(script_content)
        
        -- Salvar resultado
        if writefile then
            writefile(output_path, deobfuscated)
            print("💾 Script desofuscado salvo em:", output_path)
            print("📊 Tamanho desofuscado:", #deobfuscated, "caracteres")
        else
            print("❌ writefile não disponível")
        end
    else
        warn("❌ Arquivo vazio ou não encontrado")
    end
else
    warn("❌ Arquivo não encontrado:", script_path)
end

