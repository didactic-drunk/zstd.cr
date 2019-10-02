require "../context"
require "./dict"

# Usage:
# ```
# cctx = Zstd::Deompress::Context.new
# dbuf = cctx.compress cbuf
# ```
#
# When decompressing many times,
# it is recommended to allocate a context only once,
# and re-use it for each successive compression operation.
# This will make workload friendlier for system's memory.
# Use one context per thread for parallel execution.
class Zstd::Decompress::Context < Zstd::Context
  class Error < Zstd::Context::Error
    class FrameSizeUnknown < Error
    end
  end

  getter dict

  def initialize
    @ptr = Lib.create_d_ctx
    raise Error.new("NULL ptr create_c_ctx") if @ptr.null?
  end

  # Returns decompressed `Bytes`
  #
  # `dst` is an optional output buffer that must be >= frame_content_size
  def decompress(src : Bytes, dst : Bytes? = nil) : Bytes
    dst ||= begin
      size = frame_content_size src
      raise Error::FrameSizeUnknown.new("can't automatically determine destination size, try the streaming API") unless size
      Bytes.new size
    end

    r = Lib.decompress_d_ctx @ptr, dst, dst.bytesize, src, src.bytesize
    Error.raise_if_error r, "decompress_d_ctx"
    dst[0, r]
  end

  # Reference a prepared dictionary, to be used to decompress next frames.
  # The dictionary remains active for decompression of future frames using same DCtx.
  # Currently, only one dictionary can be managed.
  #
  # Referencing a new dictionary effectively "discards" any previous one.
  # Referencing a nil `Dict` means "return to no-dictionary mode".
  def dict=(d : Dict)
    r = Lib.d_ctx_ref_d_dict @ptr, d
    Error.raise_if_error r, "d_ctx_ref_d_dict"
    @dict = d
  end

  def dict=(buf : Bytes)
    self.dict = Dict.new buf
  end

  # :nodoc:
  CONTENT_SIZE_UNKNOWN = 0_u64 &- 1
  CONTENT_SIZE_ERROR   = 0_u64 &- 2

  # [https://facebook.github.io/zstd/zstd_manual.html#Chapter6](https://facebook.github.io/zstd/zstd_manual.html#Chapter6)
  # Returns the frame content size if known.
  #
  # Notes:
  # * Always available when using single pass compression.
  # * Not available if compressed using streaming mode.
  # * decompressed size can be very large (64-bits value), potentially larger than what local system can handle as a single memory segment. In which case, it's necessary to use streaming mode to decompress data.
  # * If source is untrusted, decompressed size could be wrong or intentionally modified. Always ensure return value fits within application's authorized limits. Each application can set its own limits.
  def frame_content_size(src : Bytes)
    r = Lib.get_frame_content_size src, src.bytesize
    case r
    when CONTENT_SIZE_UNKNOWN
      nil
    when CONTENT_SIZE_ERROR
      raise Error.new "get_frame_content_size"
    else
      r
    end
    r
  end

  # Give the _current_ memory usage of zstd context.
  #
  # Note that object memory usage can evolve (increase or decrease) over time.
  def memsize
    Lib.sizeof_d_ctx self
  end

  # :nodoc:
  def to_unsafe
    @ptr
  end

  private def free! : Nil
    Lib.free_d_ctx @ptr
  end
end
