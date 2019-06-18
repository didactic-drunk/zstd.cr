require "./context"

class Zstd::Compress::IO < IO
  class Error < Zstd::Error
  end

  @ctx = Context.new
  @obuf = Bytes.new Lib.c_stream_out_size

  delegate compression_level, :compression_level=, to: @ctx

  def initialize(@io : ::IO)
  end

  def write(slice : Bytes) : Nil
    write_loop Lib::ZstdEndDirective::ZstdEContinue, slice
  end

  def write_loop(mode, slice : Bytes? = nil) : Nil
    ibuffer = Lib::ZstdInBufferS.new
    remaining = if slice
                  ibuffer.src = slice.to_unsafe
                  ibuffer.size = slice.bytesize
                else
                  0
                end

    iptr = pointerof(ibuffer).as(Lib::ZstdInBuffer*)

    loop do
      obuffer = Lib::ZstdOutBufferS.new
      obuffer.dst = @obuf.to_unsafe
      obuffer.size = @obuf.bytesize

      optr = pointerof(obuffer).as(Lib::ZstdOutBuffer*)

      r = Lib.compress_stream2 @ctx, optr, iptr, mode
      Error.raise_if_error r, "compress_stream2"

      @io.write @obuf[0, obuffer.pos] if obuffer.pos > 0
      case mode
      when Lib::ZstdEndDirective::ZstdEContinue
        break if ibuffer.pos == remaining
      when Lib::ZstdEndDirective::ZstdEEnd
        break if r == 0
      else
        raise Error.new("unknown mode #{mode}")
      end
    end
  end

  def read(slice : Bytes)
    raise NotImplementedError.new("read")
  end

  def close : Nil
    write_loop Lib::ZstdEndDirective::ZstdEEnd
  end

  def self.open(*args)
    cio = self.new(*args)
    yield cio
  ensure
    cio.try &.close
  end
end
