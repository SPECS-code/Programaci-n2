using Plots

Nx, Ny = 100, 100
Nt = 50
dt = 0.1
Max, Min = 5.0, -5.0
r_x = range(Min, Max, length=Nx)
r_y = range(Min, Max, length=Ny)

x = [xi for xi in r_x, yj in r_y]
y = [yj for xi in r_x, yj in r_y]

anim = @animate for k in 0:Nt
    t = k * dt
    f = @. exp(-x^2 - y^2) * cos(t)

    surface(r_x, r_y, f, colormap=:viridis, zlims=(-1, 1), clims=(-1, 1))
end

gif(anim, "wave.gif", fps=10)

