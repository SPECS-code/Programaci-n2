using DelimitedFiles

min, max = -5.0, 5.0
Ni = 50
Nt = 20

x_r = range(min, max, Ni + 1)
x_y = range(min, max, Ni + 1)

dt = 2.0 * pi / Nt

open("salida_data.dat", "w") do io
    for k in 0:Nt

        t = k * dt

        f = @. exp(-x_r^2 - x_y^2) * cos(t)

        writedlm(io, f)
    end
end
