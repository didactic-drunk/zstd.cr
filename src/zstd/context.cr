require "./lib"
require "./error"

class Zstd::Context
  class Error < Zstd::Error
  end

  property compression_level = 3

  def initialize
    @ptr = Lib.create_c_ctx
    raise "NULL ptr create_c_ctx" if @ptr.null?
  end

  # overhead 1.1?
  def compress(src : Bytes, dst : Bytes = Bytes.new((src.bytesize * 1.1).to_i)) : Bytes
    r = Lib.compress_c_ctx @ptr, dst, dst.bytesize, src, src.bytesize, @compression_level
    Error.raise_if_error r, "compress_c_ctx"
    #		if Lib.is_error(r) != 0
    #			raise Error.new("compress_c_ctx", r) if r != 0
    #		end
    dst[0, r]
  end

  def decompress(src : Bytes, dst : Bytes) : Bytes
    #		r = Lib.decompress_c_ctx @ptr, dst, dst.bytesize, src, src.bytesize, @compression_level
    #		Error.raise_if_error r
    #		if Lib.is_error(r) != 0
    #			raise Error.new("compress_c_ctx", r) if r != 0
    #		end
    #		dst[0, r]
  end

  def finalize
    Lib.free_c_ctx @ptr
  end
end
