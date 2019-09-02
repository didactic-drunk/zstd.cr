require "./context"

class Zstd::Compress::IO < IO
  class Error < Zstd::Error
  end

  OUTPUT_BUFFER_SIZE = Lib.c_stream_out_size.to_i

  # Whether to close the enclosed `IO` when closing this writer.
  property? sync_close = false

  # Returns `true` if this writer is closed.
  getter? closed = false

  # Compression level (0..23)
  delegate level, :level=, to: @ctx

  @ctx = Context.new
  @obuf : Bytes

  def initialize(@io : ::IO, *, output_buffer : Bytes? = nil)
    @obuf = output_buffer || Bytes.new OUTPUT_BUFFER_SIZE
  end

  def self.open(io, *, output_buffer : Bytes? = nil)
    cio = self.new(io, output_buffer: output_buffer)
    yield cio
  ensure
    cio.try &.close
  end

  def write(slice : Bytes) : Nil
    write_loop Lib::ZstdEndDirective::ZstdEContinue, slice
  end

  private def write_loop(mode, slice : Bytes? = nil) : Nil
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
    return if @closed
    @closed = true

    write_loop Lib::ZstdEndDirective::ZstdEEnd

    @io.close if @sync_close
  end
end
