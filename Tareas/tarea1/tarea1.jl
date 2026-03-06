using Plots

f1(x) = x^10 - 1
df1(x) = 10 * x^9

f2(x) = sin(x) - x^2
df2(x) = cos(x) - 2x

f3(x) = log(x^2) - 0.7
df3(x) = 2 / x

problemas = [(f=f1, df=df1, xa=0.0, xb=3.0, x0=100.0, tol=1e-10, nombre="Problema1"),
    (f=f2, df=df2, xa=0.5, xb=1.0, x0=0.75, tol=1e-10, nombre="Problema2"),
    (f=f3, df=df3, xa=1.0, xb=2.0, x0=1.5, tol=1e-10, nombre="Problema3")]

function biseccion(f, xa, xb, tol)
    if f(xa) * f(xb) >= 0
        println("Error: La función debe tener signos opuestos en los extremos.")
        return nothing
    end

    xn = (xa + xb) / 2
    err_aprox = 1.0

    historial = Float64[xn]

    while err_aprox > tol
        if f(xa) * f(xn) < 0
            xb = xn
        elseif f(xa) * f(xn) > 0  # FIX: Correct interval condition
            xa = xn
        else
            break
        end
        xn_anterior = xn
        xn = (xa + xb) / 2
        err_aprox = abs((xn - xn_anterior) / xn)
        push!(historial, xn)
    end

    return xn, historial
end

function interpolacion(f, df, xa, xb, tol)
    if f(xa) * f(xb) >= 0
        println("Error: La función debe tener signos opuestos en los extremos.")
        return nothing
    end

    fa = f(xa)
    fb = f(xb)
    # La inicialización debe ser con la fórmula de interpolación, no bisección
    xn = xb - (fb * (xa - xb)) / (fa - fb)
    err_aprox = 1.0

    historial = Float64[xn]
    side = 0

    while err_aprox > tol
        fn = f(xn)
        if fa * fn < 0
            xb = xn
            fb = fn
            if side == -1
                fa /= 2
            end
            side = -1
        elseif fa * fn > 0
            xa = xn
            fa = fn
            if side == 1
                fb /= 2
            end
            side = 1
        else
            break
        end
        xn_anterior = xn
        xn = xb - (fb * (xa - xb)) / (fa - fb)
        err_aprox = abs((xn - xn_anterior) / xn)
        push!(historial, xn)
    end

    return xn, historial
end

function Newton_raphson(f, df, x0, tol)
    xn = x0
    err_aprox = 1.0
    historial = Float64[xn]

    while err_aprox > tol
        xv = xn

        if df(xn) == 0
            @warn "Derivada 0, no se puede continuar. Fallo por división entre cero (revisar f'(x0) == 0)"
            break
        end

        xn = xv - (f(xv)) / (df(xv))
        err_aprox = abs((xn - xv) / xn)
        push!(historial, xn)
    end

    return xn, historial
end

function graficar(hist_bis, hist_it, hist_new, nombre)
    # Gráficas individuales
    p1 = plot(hist_bis, label="Bisección", xlabel="Iteración (k)", ylabel="Valor Aproximado (α)", lw=2, marker=:circle, title="$nombre - Bisección")
    savefig(p1, "$(nombre)_Biseccion.png")

    p2 = plot(hist_it, label="Interpolación", xlabel="Iteración (k)", ylabel="Valor Aproximado (α)", lw=2, marker=:circle, title="$nombre - Interpolación")
    savefig(p2, "$(nombre)_Interpolacion.png")

    p3 = plot(hist_new, label="Newton-Raphson", xlabel="Iteración (k)", ylabel="Valor Aproximado (α)", lw=2, marker=:circle, title="$nombre - Newton-Raphson")
    savefig(p3, "$(nombre)_NewtonRaphson.png")

    # Gráfica comparativa (las 3 superpuestas)
    p_comp = plot(title="$nombre - Comparación", xlabel="Iteración (k)", ylabel="Valor Aproximado de α")
    plot!(p_comp, hist_bis, label="Bisección", lw=2, marker=:circle)
    plot!(p_comp, hist_it, label="Interpolación", lw=2, marker=:square)
    plot!(p_comp, hist_new, label="Newton-Raphson", lw=2, marker=:diamond)
    savefig(p_comp, "$(nombre)_Comparacion.png")
end

for p in problemas
    r_bis, hist_bis = biseccion(p.f, p.xa, p.xb, p.tol)
    r_it, hist_it = interpolacion(p.f, p.df, p.xa, p.xb, p.tol)
    r_new, hist_new = Newton_raphson(p.f, p.df, p.x0, p.tol)
    graficar(hist_bis, hist_it, hist_new, p.nombre)
end
