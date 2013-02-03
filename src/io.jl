# Tv: sparse matrix value type
# Ti: sparse matrix ordinal space
function pagerank_matrix(Tv::Type, Ti::Type, alpha::Float64, pathname::String)
  I, J, V = Ti[], Ti[], Tv[]
  vertices, sources  = Set{Ti}(), Set{Ti}()

  io = open(pathname, "r")
  sinks = 0
  outdegree = 0
  edges = 0
  max_ordinal = 0
  @time for line in EachLine(io)
    if sinks == outdegree
      separator = strchr(line, ' ')
      source = int32(line[1:separator - 1])
      outdegree = int32(line[separator:end])
      add!(sources, source)
      add!(vertices, source)

      if max_ordinal < source
        max_ordinal = source
      end

      sinks = 0
    else
      sink = int32(line)
      push!(I, source)
      push!(J, sink)
      push!(V, alpha / outdegree)
      add!(vertices, sink)

      if max_ordinal < sink
        max_ordinal = sink
      end

      sinks += 1
      edges += 1
    end
  end

  order = length(vertices)
  absorbing = vertices - sources
  M::SparseMatrixCSC = sparse(I, J, V, max_ordinal, max_ordinal)

  return M, keys(absorbing.hash), order, max_ordinal
end

