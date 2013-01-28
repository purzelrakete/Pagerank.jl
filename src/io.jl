# Reads an i, j sorted adjacency list. The unweighted directed graph is
# written as the adjacency matrix scaled by α and L1 normalized rowwise. The
# resulting immutable sparse matrix M can be used by the power method to
# calculate a pagerank vector.
#
# Given the following adjacency list:
#
#   1 8
#   1 6
#   1 2
#   2 1
#   2 3
#
# with vertices [1 2 3 6 8], vertex ids are projected into a compressed,
# contiguous space, ie [1:5].
#
# Projected
#
#   1 5
#   1 4
#   1 2
#   2 1
#   2 3
#
# Resorted
#
#   1 2
#   1 4
#   1 5
#   2 1
#   2 3
#
# These coordinates are then given scaled and sink normalized values
#
#   1 2 α/3
#   1 4 α/3
#   1 5 α/3
#   2 1 α/2
#   2 3 α/2
#
# This matrix of cartesian coordinates is directly converted into a sparse csc
# matrix by extracting the column vectors.
#
function pagerank_matrix(alpha::Float64, pathname::String)

  # origin to projected
  origin_idx = Dict{Int32,Int32}()

  # sequence for projected ids
  sequence = 1

  # first pass collects all origin source ids to maintain source sorting
  io = open(pathname, "r")
  for line in EachLine(io)
    fields = split(chomp(line), r"[\s,]+")
    source = int32(fields[1])

    if get(origin_idx, source, 0) == 0
      origin_idx[source] = sequence
      sequence += 1
    end
  end

  close(io)

  # second pass builds I, J, V
  io = open(pathname, "r")

  # all of these (except for V) are in projected space.
  I, J, V, sinks, absorbing = Int32[], Int32[], Float64[], Int32[], Int32[]

  # previous_source, source and sink are in origin space.
  previous_source = 0
  for line in EachLine(io)
    fields = split(chomp(line), r"[\s,]+")
    source, sink = int32(fields[1]), int32(fields[2])

    if get(origin_idx, sink, 0) == 0
      origin_idx[sink] = sequence
      push!(absorbing, sequence)
      sequence += 1
    end

    if previous_source != 0 && source != previous_source
      outdegree = length(sinks)
      value = alpha / outdegree
      sort!(sinks)

      for out in sinks
        push!(I, origin_idx[previous_source])
        push!(J, out)
        push!(V, value)
      end

      previous_source, sinks = source, [origin_idx[sink]]
    else
      previous_source = source
      push!(sinks, origin_idx[sink])
    end
  end

  outdegree = length(sinks)
  value = alpha / outdegree
  sort!(sinks)

  for out in sinks
    push!(I, origin_idx[previous_source])
    push!(J, out)
    push!(V, value)
  end

  close(io)

  size = sequence - 1
  M::SparseMatrixCSC{Float64, Int64} = sparse(I, J, V, size, size)

  return M, origin_idx, absorbing, size
end

