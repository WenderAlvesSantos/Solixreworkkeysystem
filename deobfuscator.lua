-- ============================================================
-- DESOFUSCADOR BÁSICO PARA LURAPH
-- Tenta simplificar código ofuscado com Luraph
-- ============================================================

local function deobfuscate_luraph(script_content)
    print("🔓 Iniciando desofuscação...")
    print("📊 Tamanho original:", #script_content, "caracteres")
    
    local deobfuscated = script_content
    local changes = 0
    
    -- 1. Remover comentários de ofuscação
    local before = #deobfuscated
    deobfuscated = deobfuscated:gsub("%-%- This file was protected using Luraph Obfuscator[^\n]*", "")
    changes = changes + (before - #deobfuscated)
    
    -- 2. Simplificar números hexadecimais
    deobfuscated = deobfuscated:gsub("0x([%da-fA-F]+)", function(hex)
        local num = tonumber(hex, 16)
        if num then
            changes = changes + 1
            return tostring(num)
        end
        return "0x" .. hex
    end)
    
    -- 3. Simplificar números decimais como 1.0 para 1
    deobfuscated = deobfuscated:gsub("(%d+)%.0([^%d%.])", "%1%2")
    deobfuscated = deobfuscated:gsub("(%d+)%.0$", "%1")
    
    -- 4. Simplificar comparações com 0.0
    deobfuscated = deobfuscated:gsub("==%s*0%.0", "== 0")
    deobfuscated = deobfuscated:gsub("~=%s*0%.0", "~= 0")
    deobfuscated = deobfuscated:gsub("<=%s*0%.0", "<= 0")
    deobfuscated = deobfuscated:gsub(">=%s*0%.0", ">= 0")
    
    -- 5. Tentar identificar e simplificar padrões comuns
    -- Remover expressões como (W==W and W or T) que sempre retornam W
    deobfuscated = deobfuscated:gsub("%([%w_]+)==[%w_]+%s+and%s+[%w_]+%s+or%s+[%w_]+%)", function(match)
        -- Extrair primeira variável
        local var = match:match("(%w+)")
        if var then
            changes = changes + 1
            return "(" .. var .. ")"
        end
        return match
    end)
    
    print("✅ Desofuscação básica concluída")
    print("📊 Mudanças aplicadas:", changes)
    print("📊 Tamanho final:", #deobfuscated, "caracteres")
    
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

