alpha = 0.85
accuracy = 0.00001
edgelist = "test/fixtures/gaps.adj"

rank = Rank{Float64,Int64}(alpha, accuracy, edgelist)
r = stationary_distribution(rank)
count = length(r)

iexpected = [1, 8, 3, 5, 7, 9]
expected  = [0.245344, 0.245344, 0.208173, 0.176404, 0.087356, 0.037375]
precision = 5

@assert isequal(floor(expected, precision), floor(r[iexpected], precision))

