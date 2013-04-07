# reads adjacency list format directly into a sparse csc matrix.
#
function read_adjacency_list(Tv::Type, Ti::Type, path::String, bufsize::Int64)
  io = open(path, "r")

  header = readline(io)
  nnz, height, width = map(int64, split(header))
  readline(io)

  rowval, colptr, nzval = Array(Ti, nnz), Array(Ti, width + 1), Array(Tv, nnz)

  buffer = Array(Uint8, bufsize)
  colind = 0
  edge = 0
  ordinal = 0
  sink = 0
  weight_line = false

  while !eof(io)
    fill!(buffer, 0)
    try
      read(io, buffer)
    end

    for i = 1:length(buffer)
      if buffer[i] == ' '
        source = ordinal
        weight_line = true
        ordinal = 0
      elseif buffer[i] == '\n'
        if weight_line
          weight = ordinal
          weight_line = false
          edge += 1

          rowval[edge] = source
          nzval[edge] = weight
        else
          colind += 1 # starting a new column
          gap = ordinal - sink - 1 # ie 0 gap between 14 and 15
          sink = ordinal

          colptr[colind:(colind + gap)] = edge + 1
          colind += gap
        end

        ordinal = 0
      else
        ordinal = (ordinal * 10) + (buffer[i] - 48)
      end
    end
  end

  colptr[width + 1] = nnz + 1
  close(io)

  SparseMatrixCSC(height, width, colptr, rowval, nzval)
end

function read_adjacency_list(Tv::Type, Ti::Type, path::String)
  read_adjacency_list(Tv, Ti, path, 8192)
end

