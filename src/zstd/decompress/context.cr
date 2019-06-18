require "../lib"
require "../error"

class Zstd::Decompress::Context
  class Error < Zstd::Error
  end

  def initialize
    @ptr = Lib.create_d_ctx
    raise Error.new("NULL ptr create_c_ctx") if @ptr.null?
  end

  def decompress(src : Bytes, dst : Bytes) : Bytes
    r = Lib.decompress_d_ctx @ptr, dst, dst.bytesize, src, src.bytesize
    Error.raise_if_error r, "decompress_d_ctx"
    dst[0, r]
  end

  def to_unsafe
    @ptr
  end

  def finalize
    Lib.free_d_ctx @ptr
  end
end
