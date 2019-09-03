module Zstd
end

module Zstd::Compress
  # The default compression level.
  #
  # Uses ENV["ZSTD_CLEVEL"] just like the command line utilities.
  LEVEL_DEFAULT = ENV["ZSTD_CLEVEL"]?.try(&.to_i) || 3

  LEVEL_MIN = Lib.min_c_level.to_i
  LEVEL_MAX = Lib.max_c_level.to_i
end
