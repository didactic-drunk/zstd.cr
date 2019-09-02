module Zstd
end

module Zstd::Compress
  # The default compression level.
  #
  # Uses ENV["ZSTD_CLEVEL"] just like the command line utilities.
  DEFAULT_LEVEL = ENV["ZSTD_CLEVEL"]?.try(&.to_i) || 3
end
