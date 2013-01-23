type Rank
  alpha::Float64
  iters::Int
  graph::DirectedGraph
  vertices::Int
  prior::Vector

  function Rank(alpha::Float64, iters::Int, edgelist::String)
    Rank(alpha, iters, Graphs.read_edgelist(edgelist))
  end

  function Rank(alpha::Float64, iters::Int, graph::DirectedGraph)
    vertices = length(graph.vertices)
    uniform = ones(vertices) / vertices
    new(alpha, iters, graph, vertices, uniform)
  end
end

function stationary_distribution(rank::Rank)
  println("> parsing graph")

  n = order(rank.graph)
  a = zeros(Float64, n, n)
  names = Dict{Int,Vertex}(n)

  println("> building adjacency matrix")

  for edge in edges(rank.graph)
    a[id(out(edge)), id(in(edge))] = 1
  end

  println("> building vertex lookup")

  for vertex in vertices(rank.graph)
    names[id(vertex)] = vertex
  end

  println("> building probability matrix")

  for i = 1:n
    outdegree = sum(a[i, :])

    if outdegree == 0
      a[i, :] = rank.prior[i]
    else
      a[i, :] = a[i, :] ./ outdegree
    end
  end

  a = a .* (1 - rank.alpha)
  a += rank.alpha / n

  println("> running pagerank")

  p = zeros(1, n)
  p[1] = 1

  for i in 1:rank.iters
    println(@sprintf("> %d", i))
    p = p * a
  end

  return names, p
end

