require "./lib"
require "./error"

abstract class Zstd::Context
  class Error < Zstd::Error
  end

  property compression_level = 3

  @freed = false

  def close
    free
  end

  def finalize
    free
  end

  protected def free
    return if @freed
    free!
    @freed = true
  end

  protected abstract def free! : Nil
end
