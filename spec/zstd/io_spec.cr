require "../spec_helper"
require "../../src/zstd/compress/io"
require "../../src/zstd/decompress/io"

describe Zstd::Compress::IO do
  it "Streaming API compress/decompress" do
    buf = Bytes.new 128
    buf[buf.bytesize / 2] = 255_u8

    mio = IO::Memory.new
    Zstd::Compress::IO.open(mio) do |cio|
      cio.level = 1

      buf.bytesize.times do |i|
        cio.write buf[i, 1]
      end
    end
    cbuf = mio.to_slice
    cbuf.bytesize.should be < buf.bytesize

    # # read with large buf
    mio = IO::Memory.new cbuf
    Zstd::Decompress::IO.open(mio) do |dio|
      dbuf = Bytes.new buf.bytesize * 2
      dsize = dio.read dbuf
      dsize.should eq buf.bytesize
      dbuf = dbuf[0, dsize]
      buf.should eq dbuf

      # 2nd read at eof
      dsize = dio.read Bytes.new(128)
      dsize.should eq 0
    end

    # # read with small buf
    mio = IO::Memory.new cbuf
    Zstd::Decompress::IO.open(mio) do |dio|
      dbuf = Bytes.new buf.bytesize / 2
      dsize = 0
      2.times do
        ds = dio.read dbuf
        dsize += ds
        ds.should eq dbuf.bytesize
      end
      dsize.should eq buf.bytesize

      # 3rd read at eof
      dsize = dio.read Bytes.new(128)
      dsize.should eq 0
    end
  end
end
