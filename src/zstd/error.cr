module Zstd
  class Error < Exception
    def self.raise_if_error(r, msg)
      raise self.new(r, msg) if Lib.is_error(r) != 0
    end

    def initialize(r, msg : String)
      super "#{msg} returned #{r}"
    end

    def initialize(msg : String)
      super msg
    end
  end
end
