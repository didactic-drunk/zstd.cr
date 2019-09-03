require "io"
require "./context"

class Zstd::Decompress::IO < ::IO
  class Error < Zstd::Error
  end

  INPUT_BUFFER_SIZE = Lib.d_stream_in_size.to_i

  # Whether to close the enclosed `IO` when closing this reader.
  property? sync_close = false

  # Returns `true` if this writer is closed.
  getter? closed = false

  @ctx = Context.new
  @ibuf : Bytes
  @ieof = false
  @oeof = false
  @more_output = false

  @ibuffer = Lib::ZstdInBufferS.new

  def initialize(@io : ::IO, @sync_close = false, @dict : Bytes? = nil, *, input_buffer : Bytes? = nil)
    # TODO: dict
    raise NotImplementedError.new("missingd dict support") if @dict
    @ibuf = input_buffer || Bytes.new INPUT_BUFFER_SIZE
    @ibuffer.src = @ibuf.to_unsafe
  end

  def self.open(io, sync_close = false, dict : Bytes? = nil, *, input_buffer = nil)
    dio = self.new(io, sync_close: sync_close, dict: dict, input_buffer: input_buffer)
    yield dio
  ensure
    dio.try &.close
  end

  # :nodoc:
  def io=(@io : ::IO)
    @ibuffer.pos = 0
    @ibuffer.size = 0
    @more_output = false
    @ieof = false
    @oeof = false
    @closed = false
  end

  def read(slice : Bytes)
    check_open
    return 0 if @oeof

    obuffer = Lib::ZstdOutBufferS.new
    obuffer.dst = slice.to_unsafe
    obuffer.size = slice.bytesize

    iptr = pointerof(@ibuffer).as(Lib::ZstdInBuffer*)
    optr = pointerof(obuffer).as(Lib::ZstdOutBuffer*)

    # Feed input to decompress_stream until obuffer has data or end of input or output
    until @ieof || @oeof || obuffer.pos != 0
      fill_buffer

      r = Lib.decompress_stream @ctx.to_unsafe.as(Lib::ZstdDCtx*), optr, iptr
      Error.raise_if_error r, "decompress_stream2"
      @oeof = 0 if r == 0

      # But if `output.pos == output.size`, there might be some data left within internal buffers.,
      # In which case, call ZSTD_decompressStream() again to flush whatever remains in the buffer.
      @more_output = obuffer.pos == obuffer.size ? true : false
    end

    obuffer.pos
  end

  private def fill_buffer
    return if @ieof || @oeof || @more_output || @ibuffer.size > 0 && @ibuffer.pos != @ibuffer.size

    @ibuffer.pos = 0

    len = @io.read @ibuf
    @ibuffer.size = len.to_i64
    @ieof = true if len == 0
  end

  def write(slice : Bytes) : Nil
    raise NotImplementedError.new("write")
  end

  def close : Nil
    return if @closed
    @closed = true

    @io.close if @sync_close
  end
end
