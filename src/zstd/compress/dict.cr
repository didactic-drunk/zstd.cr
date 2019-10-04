require "../lib"

module Zstd::Compress
  class Dict
    # :nodoc:
    # Used internally by `Zstd::Dict`
    def initialize(buf : Bytes, level : Int32)
      # @ptr = Lib.create_c_dict buf, buf.bytesize, level
      @ptr = Lib.create_c_dict_by_reference buf, buf.bytesize, level
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
