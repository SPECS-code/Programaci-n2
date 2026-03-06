using Printf

function newton_modificado(f, df, ddf, x0; tol=1e-8, max_iter=100)
    x = x0
    for i in 1:max_iter
        fx = f(x)
        dfx = df(x)
        ddfx = ddf(x)

        denom = dfx^2 - fx * ddfx
        if abs(denom) < 1e-14
            return x, i
        end

        dx = (fx * dfx) / denom
        x_new = x - dx

        if abs(x_new - x) < tol
            return x_new, i
        end
        x = x_new
    end
    return x, max_iter
end

# Función para explorar el dominio y encontrar intervalos con cambios de signo o puntos críticos
function explorar_dominio(f, df, a, b, n_puntos)
    x = range(a, b, length=n_puntos)

    println("Explorando el dominio [$(a), $(b)] con $n_puntos puntos...")

    raiz_intervalos = []
    puntos_criticos = []

    for i in 1:(n_puntos-1)
        # Cambio de signo en f(x) (indica raíz de multiplicidad impar, por ejemplo simple)
        if f(x[i]) * f(x[i+1]) <= 0
            push!(raiz_intervalos, (x[i], x[i+1]))
        end
        # Cambio de signo en f'(x) (indica punto crítico, máximo o mínimo local)
        if df(x[i]) * df(x[i+1]) <= 0
            push!(puntos_criticos, (x[i], x[i+1]))
        end
    end

    println("\nLos cambios de signo de f(x) (posibles raíces simples/impares) ocurren en:")
    for inter in raiz_intervalos
        @printf("- Intervalo: [%.2f, %.2f]\n", inter[1], inter[2])
    end

    println("\nLos cambios de signo de f'(x) (puntos críticos) ocurren cerca de:")
    for inter in puntos_criticos
        @printf("- Intervalo: [%.2f, %.2f] -> Si f(x) ≈ 0 aquí, hay una raíz múltiple.\n", inter[1], inter[2])
    end
    return raiz_intervalos, puntos_criticos
end


println("="^60)
println("Problema 1: Localizar raíces de (x-2)^4 - 10(x-2)^2 = 0")
println("="^60)

f1(x) = (x - 2)^4 - 10 * (x - 2)^2
df1(x) = 4 * (x - 2)^3 - 20 * (x - 2)
ddf1(x) = 12 * (x - 2)^2 - 20

# Exploración del dominio elegido: [-3, 7]
explorar_dominio(f1, df1, -3.0, 7.0, 100)

println("\nAplicando Método de Newton Modificado a las aproximaciones encontradas:")
# Elegimos puntos iniciales basados en la exploración del dominio
# Hay cambios de signo de f(x) cerca de -1 y 5.
# Hay un punto crítico con f(x) ≈ 0 en x=2, sugiriendo una raíz múltiple par.
x_init1 = [-1.5, 2.0, 5.5]
for x0 in x_init1
    r, iters = newton_modificado(f1, df1, ddf1, x0)
    @printf("Partiendo de x0=%5.1f -> Raíz encontrada: %9.6f (en %d iteraciones)\n", x0, r, iters)
end


println("\n" * "="^60)
println("Problema 2: Localización de raíz triple de (x-2)^3 = 0")
println("="^60)

f2(x) = (x - 2)^3
df2(x) = 3 * (x - 2)^2
ddf2(x) = 6 * (x - 2)

# Exploración del dominio: [0, 4]
explorar_dominio(f2, df2, 0.0, 4.0, 50)

println("\nAplicando Método de Newton Modificado para la raíz triple:")
r2, iters2 = newton_modificado(f2, df2, ddf2, 0.0)
@printf("Partiendo de x0=0.0 -> Raíz encontrada: %.6f (en %d iteraciones)\n", r2, iters2)

println("\nAplicando Método de Newton Clásico conociendo multiplicidad m=3:")
# Para Newton clásico sabiendo la multiplicidad: x_{n+1} = x_n - m * (f(x_n)/f'(x_n))
function newton_multiplicidad(f, df, x0, m=3, tol=1e-8, max_iter=100)
    x = x0
    for i in 1:max_iter
        fx = f(x)
        dfx = df(x)
        if abs(dfx) < 1e-14
            return x, i
        end
        # The original 'break' and 'end' lines were removed as per the instruction's implied change.

        x_new = x - m * (fx / dfx)

        if abs(x_new - x) < tol
            return x_new, i
        end
        x = x_new
    end
    return x, max_iter
end

r2_m, iters2_m = newton_multiplicidad(f2, df2, 0.0, 3)
@printf("Partiendo de x0=0.0 -> Raíz encontrada: %.6f (en %d iteraciones)\n", r2_m, iters2_m)
