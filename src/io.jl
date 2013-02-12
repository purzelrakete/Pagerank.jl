# Tv: sparse matrix value type
# Ti: sparse matrix ordinal space
function readadj(Tv::Type, Ti::Type, alpha::Float64, path::String)
  I, J, V = Ti[], Ti[], Tv[]
  vertices, sources  = Set{Ti}(), Set{Ti}()

  io = open(path, "r")
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

  close(io)

  order = length(vertices)
  absorbing = vertices - sources
  M::SparseMatrixCSC = sparse(I, J, V, max_ordinal, max_ordinal)

  return M, keys(absorbing.hash), order, max_ordinal
end

# Tv: sparse matrix value type
# Ti: sparse matrix ordinal space
function fastadj(Tv::Type, Ti::Type, alpha::Float64, path::String, bufsize::Int64)
  edges = count_edges(path)
  I, J, V = Array(Ti, edges), Array(Ti, edges), Array(Tv, edges)
  vertices, sources = Set{Ti}(), Set{Ti}()
  max_ordinal = 0

  open(path, "r") do io
    buffer = Array(Uint8, bufsize)
    ordinal = 0
    sinks = 0
    outdegree = 0
    edge = 0
    while !eof(io)
      fill!(buffer, 0)
      try
        read(io, buffer)
      end

      for i = 1:length(buffer)
        if buffer[i] == '\n'
          if sinks == 0
            outdegree = ordinal
          else
            sink = ordinal
            add!(vertices, sink)
            if max_ordinal < sink
              max_ordinal = sink
            end

            edge += 1
            I[edge] = source
            J[edge] = sink
            V[edge] = alpha / outdegree
          end

          sinks += 1
          ordinal = 0
        elseif buffer[i] == ' '
          source = ordinal
          add!(sources, source)
          add!(vertices, source)
          if max_ordinal < source
            max_ordinal = source
          end

          sinks = 0
          ordinal = 0
        else
          ordinal = (ordinal * 10) + (buffer[i] - 48)
        end
      end
    end
  end

  order = length(vertices)
  absorbing = vertices - sources
  M::SparseMatrixCSC = sparse(I, J, V, max_ordinal, max_ordinal)

  return M, keys(absorbing.hash), order, max_ordinal
end

function fastadj(Tv::Type, Ti::Type, alpha::Float64, path::String)
  fastadj(Tv, Ti, alpha, path, 8192)
end

function count_edges(path::String)
  lines = countlines(path)
  spaces = countlines(path, ' ') - 1 # broken?
  lines - spaces
end

