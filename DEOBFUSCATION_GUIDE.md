# Guia de Desofuscação - Luraph Obfuscator

## Opções Disponíveis

### 1. Desofuscador Básico (deobfuscator.lua)
Execute no executor:
```lua
loadstring(readfile("deobfuscator.lua"))()
```

Este desofuscador faz simplificações básicas:
- Remove comentários de ofuscação
- Converte números hexadecimais para decimais
- Simplifica expressões numéricas (1.0 → 1)
- Remove espaços desnecessários

**Limitações:** Não remove ofuscação avançada de strings, variáveis ou lógica.

### 2. LuraphDeobfuscator (Ferramenta Externa)

**Requisitos:**
- Java instalado
- LuraphDeobfuscator.jar
- unluac.jar (decompilador Lua)

**Passos:**

1. **Baixar ferramentas:**
   - LuraphDeobfuscator: https://github.com/PhoenixZeng/LuraphDeobfuscator
   - unluac: https://github.com/ingmar/unluac

2. **Converter para bytecode:**
   ```bash
   java -jar LuraphDeobfuscator.jar -i captured_script.lua -o script.luac
   ```

3. **Decompilar bytecode:**
   ```bash
   java -jar unluac.jar script.luac > deobfuscated_script.lua
   ```

**Nota:** Pode não funcionar perfeitamente com Luraph v14.5.1 (versão recente).

### 3. Desofuscação Manual

Para scripts muito ofuscados, pode ser necessário:
1. Executar o script em um ambiente controlado
2. Usar hooks para capturar strings e funções em runtime
3. Reconstruir o código baseado no comportamento observado

## Recomendação

Para este script específico (Luraph v14.5.1), recomendo:
1. Tentar o desofuscador básico primeiro
2. Se não funcionar bem, usar o script original com key (funciona perfeitamente)
3. Ou tentar ferramentas externas se tiver Java instalado

