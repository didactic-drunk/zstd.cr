require "./lib"
require "./error"

abstract class Zstd::Context
  class Error < Zstd::Error
  end

  @freed = false

  # TODO: copycctx, copydctx
  def dup
    raise NotImplementedError.new
  end

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
