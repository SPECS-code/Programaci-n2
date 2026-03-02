using Plots

xmin = -1.0
xmax = 1.0
N = 100
x = range(xmin, xmax, length=N)
y = sqrt.(abs.(x))

plot(x, y, label="sqrt(|x|)", marker=:circle)
savefig("sqrt_abs_x.png")