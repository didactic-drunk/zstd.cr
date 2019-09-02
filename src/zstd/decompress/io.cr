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
  @ibuf_size = 0_i64
  @ibuf_pos = 0_i64
  @ieof = false

  def initialize(@io : ::IO, @sync_close = false, @dict : Bytes? = nil, *, input_buffer : Bytes? = nil)
    # TODO: dict
    raise NotImplementedError.new("missingd dict support") if @dict
    @ibuf = input_buffer || Bytes.new INPUT_BUFFER_SIZE
  end

  def self.open(io, sync_close = false, dict : Bytes? = nil, *, input_buffer = nil)
    dio = self.new(io, sync_close: sync_close, dict: dict, input_buffer: input_buffer)
    yield dio
  ensure
    dio.try &.close
  end

  def read(slice : Bytes)
    check_open
    fill_buffer unless @ieof
    return 0 if @ieof

    ibuffer = Lib::ZstdInBufferS.new
    ibuffer.src = @ibuf.to_unsafe
    ibuffer.size = @ibuf.bytesize
    ibuffer.pos = @ibuf_pos

    obuffer = Lib::ZstdOutBufferS.new
    obuffer.dst = slice.to_unsafe
    obuffer.size = slice.bytesize

    iptr = pointerof(ibuffer).as(Lib::ZstdInBuffer*)
    optr = pointerof(obuffer).as(Lib::ZstdOutBuffer*)

    # return 3
    r = Lib.decompress_stream @ctx.to_unsafe.as(Lib::ZstdDCtx*), optr, iptr
    @ibuf_pos = ibuffer.pos.to_i64
    Error.raise_if_error r, "decompress_stream2"

    obuffer.pos
  end

  private def fill_buffer
    return @ibuf_size if @ibuf_size > 0 && @ibuf_pos != @ibuf_size

    @ibuf_pos = 0

    len = @io.read @ibuf
    @ibuf_size = len.to_i64
    @ieof = true if len == 0
    len
  end

  def write(slice : Bytes) : Nil
    raise NotImplementedError.new("write")
  end

  def close : Nil
    return if @closed
    @closed = true

    @ctx.close

    @io.close if @sync_close
  end
end
