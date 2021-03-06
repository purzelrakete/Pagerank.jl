alpha = 0.85
list = "test/fixtures/dangling.adj"
order = 6

M, order, max_ordinal = fastadj(Float64, Int64, alpha, list, 8)

expected = sparse([
 0.0  0.85     0.0      0.0      0.0      0.0
 0.0  0.0      0.425    0.425    0.0      0.0
 0.0  0.28333  0.0      0.28333  0.28333  0.0
 0.0  0.28333  0.28333  0.0      0.28333  0.0
 0.0  0.0      0.28333  0.28333  0.0      0.28333
 0.0  0.0      0.0      0.0      0.0      0.0
])

difference = (max(dense(expected) - dense(M)))

@assert isequal(6, order)
@assert isequal(6, max_ordinal)
@assert isequal(0, difference)

