require "semantic_version"

module Zstd
  VERSION = "1.1.2"

  LIB_VERSION         = SemanticVersion.parse String.new(Lib.version_string)
  LIB_VERSION_MINIMUM = SemanticVersion.parse("1.4.4")
  raise "unsupported zstd version #{LIB_VERSION}, needs #{LIB_VERSION_MINIMUM}" unless LIB_VERSION >= LIB_VERSION_MINIMUM

  LEVEL_DEFAULT = ENV["ZSTD_CLEVEL"]?.try(&.to_i) || 3
end
