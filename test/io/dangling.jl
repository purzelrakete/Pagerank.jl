alpha = 0.85
list = "test/fixtures/dangling.adj"
order = 6

M, height, width = read_adjacency_list(Float64, Int64, list, 8)

expected = sparse([
 0.0  1.0      0.0      0.0      0.0      0.0
 0.0  0.0      0.5      0.5      0.0      0.0
 0.0  0.33333  0.0      0.33333  0.33333  0.0
 0.0  0.33333  0.33333  0.0      0.33333  0.0
 0.0  0.0      0.33333  0.33333  0.0      0.33333
 0.0  0.0      0.0      0.0      0.0      0.0
])

println(M)
println(height)
println(width)

difference = (max(dense(expected) - dense(M)))

@assert isequal(6, order)
@assert isequal(6, max_ordinal)
@assert isequal(0, difference)

