alpha = 0.85
list = "test/fixtures/dangling.adj"
order = 6

M, absorbing, order, max_ordinal = readadj(Float64, Int64, alpha, list)

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
@assert isequal([6], absorbing)
