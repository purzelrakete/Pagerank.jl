type Rank
  alpha::Float32
  iterations::Int
  edgelist::String

  Rank(alpha, iterations, edgelist) = new(alpha, iterations, edgelist)
end

function stationary_distribution(rank::Rank)
  println("> parsing edgelist")

  g = read_edgelist(rank.edgelist)
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

  a = a .* (1 - rank.alpha)
  a += rank.alpha / n

  println("> running pagerank")

  p = zeros(1, n)
  p[1] = 1

  for i in 1:rank.iterations
    println(@sprintf("> %d", i))
    p = p * a
  end

  return names, p
end

