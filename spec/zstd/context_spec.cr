require "../spec_helper"
require "../../src/zstd/compress/context"
require "../../src/zstd/decompress/context"

describe Zstd::Compress::Context do
  it "Simple API compress/decompress" do
    buf = Bytes.new 128
    buf[buf.bytesize / 2] = 1_u8

    cctx = Zstd::Compress::Context.new
    cctx.level = 1
    cctx.level.should eq 1
    dctx = Zstd::Decompress::Context.new

    cbuf = cctx.compress buf
    cctx.level.should eq 1
    dbuf = dctx.decompress cbuf

    cbuf.bytesize.should be < dbuf.bytesize
    dbuf.should eq buf
  end
end
