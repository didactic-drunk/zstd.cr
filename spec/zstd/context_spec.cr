require "../spec_helper"
require "../../src/zstd/compress/context"
require "../../src/zstd/decompress/context"

describe Zstd::Compress::Context do
  it "Simple API compress/decompress" do
    buf = Bytes.new 128
    buf[buf.bytesize / 2] = 1_u8

    cctx = Zstd::Compress::Context.new
    p cctx.compression_level
    cctx.compression_level = 1
    p cctx.compression_level
    dctx = Zstd::Decompress::Context.new

    cbuf = cctx.compress buf
    p cctx.compression_level
    dbuf = dctx.decompress cbuf, Bytes.new(buf.bytesize)

    cbuf.bytesize.should be < dbuf.bytesize
    dbuf.should eq buf
  end
end
