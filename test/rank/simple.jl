alpha = 0.5
accuracy = 0.0000001
edgelist = "test/fixtures/simple.adj"

rank = Rank{Float64,Int64}(alpha, accuracy, edgelist)
r = stationary_distribution(rank)
count = length(r)

expected = [float(5 / 18), float(4 / 9), float(5 / 18)]
precision = 5

@assert isequal(floor(expected, precision), floor(r, precision))

