require "../lib"

module Zstd::Decompress
  class Dict
    # :nodoc:
    # Used internally by `Zstd::Dict`
    def initialize(buf : Bytes)
      # @ptr = Lib.create_d_dict buf, buf.bytesize
      @ptr = Lib.create_d_dict_by_reference buf, buf.bytesize
    end

    def dict_id
      Lib.get_dict_id_from_d_dict self
    end

    # Give the _current_ memory usage of zstd dictionary.
    #
    # Note that object memory usage can evolve (increase or decrease) over time.  Maybe?
    def memsize
      Lib.sizeof_d_dict self
    end

    # :nodoc:
    def to_unsafe
      @ptr
    end

    def finalize
      Lib.free_d_dict @ptr
    end
  end
end
