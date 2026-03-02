using Printf

function mostrar_matriz(M)
    filas, columnas = size(M)
    for i in 1:filas
        print("   ") # Margen izquierdo
        for j in 1:columnas
            valor = M[i, j]
            # Limpieza básica de precisión y el molesto -0.0
            valor = round(valor, digits=4) + 0.0

            if isinteger(valor)
                @printf("%8d", Int(valor))
            else
                @printf("%8.2f", valor)
            end
        end
        println()
    end
end

matriz_value = []

println("\n" * "═"^50)
println("  SISTEMA DE ESCALONAMIENTO")
println("═"^50)
println("\n Escriba su matriz (números con espacios).")
println(" Presione ENTER en una línea vacía para procesar:")

while true
    print("\n > ")
    entrada = readline()
    if isempty(strip(entrada))
        break
    end
    try
        local fila = parse.(Float64, split(entrada))
        push!(matriz_value, fila)
    catch
        println("  [Error] Entrada no válida. Use números y espacios.")
    end
end

if isempty(matriz_value)
    println("\n[!] No se ingresó ninguna matriz. Saliendo...")
    exit()
end

matriz = hcat(matriz_value...)' |> copy
filas, columnas = size(matriz)

println("\n" * "─"^50)
println(" MATRIZ ORIGINAL:")
println("─"^50)
mostrar_matriz(matriz)

# === FASE 1: ESCALONAMIENTO HACIA ABAJO (REF) ===
for i in 1:min(filas, columnas)
    # 1. PIVOTEO PARCIAL
    if abs(matriz[i, i]) < 1e-10
        for k in (i+1):filas
            if abs(matriz[k, i]) > 1e-10
                matriz[i, :], matriz[k, :] = matriz[k, :], matriz[i, :]
                println("\n  INTERCAMBIO: Fila $i ↔ Fila $k")
                mostrar_matriz(matriz)
                break
            end
        end
    end

    pivote = matriz[i, i]

    # 2. NORMALIZACIÓN (Hacer el pivote 1)
    if abs(pivote) > 1e-10
        matriz[i, :] ./= pivote
        println("\n  PASO $i (Normalizar pivote en 1):")
        mostrar_matriz(matriz)

        # 3. ELIMINACIÓN HACIA ABAJO
        for k in (i+1):filas
            factor = matriz[k, i]
            if abs(factor) > 1e-10
                matriz[k, :] .-= factor .* matriz[i, :]
                println("  Fila $k (Hacer cero debajo):")
                mostrar_matriz(matriz)
            end
        end
    end
end

# === FASE 2: REDUCCIÓN HACIA ARRIBA (RREF) ===
println("\n" * "-"^50)
println(" INICIANDO REDUCCIÓN HACIA ARRIBA (RREF)")
println("-"^50)

for i in filas:-1:1
    # Buscar el pivote (el primer 1)
    col_pivote = findfirst(x -> abs(x - 1.0) < 1e-10, matriz[i, :])

    if col_pivote !== nothing
        for k in (i-1):-1:1
            factor = matriz[k, col_pivote]
            if abs(factor) > 1e-10
                matriz[k, :] .-= factor .* matriz[i, :]
                println("\n  Limpiando columna encima de Fila $i:")
                mostrar_matriz(matriz)
            end
        end
    end
end

println("\n" * "="^50)
println(" RESULTADO FINAL (FORMA ESCALONADA REDUCIDA):")
println("="^50)
mostrar_matriz(matriz)
println()