require "../context"
require "../compress"

class Zstd::Compress::Context < Zstd::Context
  class Error < Zstd::Context::Error
  end

  def initialize(level : Int32 = DEFAULT_LEVEL)
    @ptr = Lib.create_c_ctx
    raise Error.new("NULL ptr create_c_ctx") if !@ptr || @ptr.null?

    self.level = level
  end

  def compress(src : Bytes, dst : Bytes = Bytes.new(compress_bound(src.bytesize))) : Bytes
    r = Lib.compress2 @ptr, dst, dst.bytesize, src, src.bytesize
    Error.raise_if_error r, "compress_c_ctx"
    dst[0, r]
  end

  # TODO: more parameters.

  {% for name, param in {"level" => "ZstdCCompressionLevel", "nb_workers" => "ZstdCNbWorkers"} %}
		def {{name.id}}
			get_param Lib::ZstdCParameter::{{param.id}}
		end

		def {{name.id}}=(val)
			set_param Lib::ZstdCParameter::{{param.id}}, val
		end
	{% end %}

  # Maximum output buffer size for compression
  def compress_bound(size)
    r = Lib.compress_bound size
    Error.raise_if_error r, "compress_bound"
    r
  end

  # [https://facebook.github.io/zstd/zstd_manual.html#Chapter6](https://facebook.github.io/zstd/zstd_manual.html#Chapter6)
  # Returns the frame content size if known.
  def frame_content_size(src : Bytes)
    r = Lib.get_frame_content_size src.bytesize
    Error.raise_if_error r, "Lib.get_frame_content_size"
    # BUG: nil for ZSTD_CONTENTSIZE_UNKNOWN
    r
  end

  private def get_param(key)
    r = Lib.c_ctx_get_parameter @ptr, key, out val
    Error.raise_if_error r, "c_ctx_get_parameter"
    val
  end

  private def set_param(key, val)
    r = Lib.c_ctx_set_parameter @ptr, key, val
    Error.raise_if_error r, "c_ctx_set_parameter"
    val
  end

  def to_unsafe
    @ptr
  end

  def free!
    Lib.free_c_ctx @ptr
  end
end
