require "../lib"

module Zstd::Compress
  class Dict
    # Create a digested dictionary, ready to start decompression operation without startup delay.
    # May be shared between multiple `Context`'s
    # `buf` is copied and may be reused or modified.
    def initialize(buf : Bytes, level : Int32)
      @ptr = Lib.create_c_dict buf, buf.bytesize, level
    end

    def dict_id
      Lib.get_dict_id_from_c_dict self
    end

    # Give the _current_ memory usage of zstd dictionary.
    #
    # Note that object memory usage can evolve (increase or decrease) over time.  Maybe?
    def memsize
      Lib.sizeof_c_dict self
    end

    # :nodoc:
    def to_unsafe
      @ptr
    end

    def finalize
      Lib.free_c_dict @ptr
    end
  end
end
