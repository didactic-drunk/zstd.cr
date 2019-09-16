require "semantic_version"

module Zstd
  VERSION = "1.0.0"

  LIB_VERSION         = SemanticVersion.parse String.new(Lib.version_string)
  LIB_VERSION_MINIMUM = SemanticVersion.parse("1.4.0")
  raise "unsupported zstd version #{LIB_VERSION}, needs #{LIB_VERSION_MINIMUM}" unless LIB_VERSION >= LIB_VERSION_MINIMUM
end
