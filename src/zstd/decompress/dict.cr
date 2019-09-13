module Zstd::Decompress
  class Dict
    # Create a digested dictionary, ready to start decompression operation without startup delay.
    # May be shared between multiple `Context`'s
    # `buf` is copied and may be reused or modified.
    def initialize(buf : Bytes)
      @ptr = Lib.create_d_dict buf, buf.bytesize
    end

    def finalize
      Lib.free_d_dict @ptr
    end
  end
end
