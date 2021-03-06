# Bandpass fitler example 
using MarketCycles
using Gadfly

# Generate dummy data
srand(6)
n = 2500
op = 100.0 + cumsum(randn(n))
hi = op + rand(n)
lo = op - rand(n)
cl = 100.0 + cumsum(randn(n))
index = collect(1:1:length(cl))
for i = 1:n
	if cl[i] > hi[i]
		cl[i] = hi[i]
	elseif cl[i] < lo[i]
		cl[i] = lo[i]
	end
end

# Apply Bandpass Filter
BP_Filter = BandPassFilter(cl,n=30,bandwidth=.3)

# Plot
white_panel = Theme(
    panel_fill="white",
    default_color="blue",
    background_color="white"
)
p1 = plot(x=index,y=cl,Geom.line,
Guide.xlabel(nothing), Guide.ylabel("Price"), Guide.title("Dummy Data"),white_panel)
p2 = plot(x=index,y=BP_Filter,Geom.line,Guide.xlabel("Time Index"),Guide.title("BandPass Filter"), Guide.ylabel("BP Filter"),white_panel)
out = vstack(p1,p2)

# Save Plot
draw(PNG("C:/Users/Andrew.Bannerman/Desktop/Julia/BP_example.png", 1500px, 800px), out)
