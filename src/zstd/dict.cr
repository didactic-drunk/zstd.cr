require "./compress/dict"
require "./decompress/dict"

class Zstd::Dict
  @@mutex = Mutex.new

  @buf : Bytes

  # Create a digested dictionary, ready to start compression or decompression operation without startup delay.
  #
  # May be shared between multiple `Context`'s.
  #
  # `buf` is copied and may be reused or modified.
  def initialize(buf : Bytes, @level : Int32 = LEVEL_DEFAULT)
    @buf = buf.dup
  end

  def dict_id
    Lib.get_dict_id_from_dict @buf, @buf.bytesize
  end

  # The compression dictionary.
  getter cdict : Compress::Dict do
    @@mutex.synchronize do
      Compress::Dict.new @buf, @level
    end
  end

  # The decompression dictionary.
  getter ddict : Decompress::Dict do
    @@mutex.synchronize do
      Decompress::Dict.new @buf
    end
  end

  # Sum of @buf.bytesize, compression and decompression dictionary sizes reported by Zstandard.
  #
  # Doesn't include crystal object overhead which is probably less than 52 bytes.
  def memsize
    {@buf.bytesize, @cdict.try(&.memsize) || 0, @ddict.try(&.memsize) || 0}.sum
  end
end
