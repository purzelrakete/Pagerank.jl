require("Graphs")
using Graphs

alpha = 0.85
iterations = 100

println("> parsing edgelist")

g = read_edgelist("data/test.txt")
n = order(g)
a = zeros(Float64, n, n)
names = Dict{Int,Vertex}(n)

println("> building adjacency matrix")

for edge in edges(g)
  a[id(out(edge)), id(in(edge))] = 1
end

println("> building vertex lookup")

for vertex in vertices(g)
  names[id(vertex)] = vertex
end

println("> building probability matrix")

for i = 1:n
  outdegree = sum(a[i, :])

  if outdegree == 0
    a[i, :] = 1.0 / n
  else
    a[i, :] = a[i, :] ./ outdegree
  end
end

a = a .* (1 - alpha)
a += alpha / n

println("> running pagerank")

p = zeros(1, n)
p[1] = 1

for i in 1:iterations
  println(@sprintf("> %d", i))
  p = p * a
end

println("> done pagerank")

for i in 1:n
  println(@sprintf("%s	%s", label(names[i]), p[i]))
end

