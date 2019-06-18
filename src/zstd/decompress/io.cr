require "io"
require "./context"

class Zstd::Decompress::IO < ::IO
  class Error < Zstd::Error
  end

  @ctx = Context.new
  @ibuf = Bytes.new Lib.d_stream_in_size
  @ibuf_size = 0_i64
  @ibuf_pos = 0_i64
  @ieof = false

  def initialize(@io : ::IO)
  end

  def read(slice : Bytes)
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
    # TODO: conditionally close @io
  end

  def self.open(*args)
    dio = self.new(*args)
    yield dio
  ensure
    dio.try &.close
  end
end
