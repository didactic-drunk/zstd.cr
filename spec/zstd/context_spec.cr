require "../spec_helper"
require "../../src/zstd/compress/context"
require "../../src/zstd/decompress/context"

private def contexts_with_bufs
  buf = Bytes.new 128
  buf[buf.bytesize // 2] = 1_u8

  dbuf2 = Bytes.new buf.bytesize

  cctx = Zstd::Compress::Context.new(level: 1)
  dctx = Zstd::Decompress::Context.new

  {cctx, dctx, buf, dbuf2}
end

describe Zstd::Compress::Context do
  it "Simple API compress/decompress with auto buffer" do
    cctx, dctx, buf, dbuf2 = contexts_with_bufs

    cctx.level = 1
    cctx.level.should eq 1

    cbuf = cctx.compress buf
    cctx.level.should eq 1
    dbuf = dctx.decompress cbuf

    cbuf.bytesize.should be < dbuf.bytesize
    dbuf.should eq buf
  end

  it "Simple API compress/decompress with destination buffer" do
    cctx, dctx, buf, dbuf2 = contexts_with_bufs

    cbuf = cctx.compress buf
    dbuf = dctx.decompress cbuf, dbuf2

    cbuf.bytesize.should be < dbuf.bytesize
    dbuf.should eq buf
  end

  it "Simple API compress/decompress raises with small destination buffer" do
    cctx, dctx, buf, dbuf2 = contexts_with_bufs
    cbuf = cctx.compress buf

    dbuf2 = Bytes.new 1
    expect_raises Zstd::Decompress::Context::Error do
      dbuf = dctx.decompress cbuf, dbuf2
    end
  end

  it "Simple API compress/decompress with checksums" do
    cctx, dctx, buf, dbuf2 = contexts_with_bufs

    cctx.level = 1

    cbuf = cctx.compress buf

    cctx.checksum = true

    cbuf2 = cctx.compress buf
    cctx.checksum.should be_true
    cbuf2.bytesize.should eq(cbuf.bytesize + 4)
    dbuf = dctx.decompress cbuf2

    dbuf.should eq buf
  end

  it "memsizes" do
    cctx, dctx, _, _ = contexts_with_bufs
    cctx.memsize.should be > 0
    dctx.memsize.should be > 0
  end
end
