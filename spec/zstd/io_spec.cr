require "../spec_helper"
require "../../src/zstd/compress/io"
require "../../src/zstd/decompress/io"
require "random"

describe Zstd::Compress::IO do
  it "Streaming API compress/decompress" do
    buf = Bytes.new 128
    buf[buf.bytesize // 2] = 255_u8

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
      dbuf = Bytes.new buf.bytesize // 2
      dsize = 0
      2.times do
        ds = dio.read dbuf
        dsize += ds
        ds.should eq dbuf.bytesize
      end
      dsize.should eq buf.bytesize

      # 3rd read at eof
      dbuf2 = Bytes.new(128)
      dsize = dio.read dbuf2
      dsize.should eq 0
    end

    # # read single byte at a time
    mio = IO::Memory.new cbuf
    Zstd::Decompress::IO.open(mio) do |dio|
      dbuf = Bytes.new 1
      dbuf2 = Bytes.new(buf.bytesize)
      dsize = 0
      buf.bytesize.times do |i|
        ds = dio.read dbuf
        dsize += ds
        ds.should eq dbuf.bytesize
        dbuf2[i] = dbuf[0]
      end
      dsize.should eq buf.bytesize
      dbuf2.should eq buf

      # last read at eof
      dsize = dio.read dbuf2
      dsize.should eq 0
    end
  end

  it "Streaming API compress/decompress with large data" do
    random = Random.new 0
    buf = random.random_bytes 10*1024*1024

    mio = IO::Memory.new
    Zstd::Compress::IO.open(mio) do |cio|
      buf.bytesize.times do |i|
        cio.write buf[i, 1]
      end
    end
    cbuf = mio.to_slice
    # +|- 2%
    (cbuf.bytesize - buf.bytesize).abs.should be < (buf.bytesize * 0.02)

    # # read with large buf
    mio = IO::Memory.new cbuf
    Zstd::Decompress::IO.open(mio) do |dio|
      dbuf = Bytes.new buf.bytesize * 2
      dptr = dbuf.to_slice
      dsize = 0
      loop do
        ds = dio.read dptr
        break if ds == 0
        dptr += ds
        dsize += ds
      end
      dsize.should eq buf.bytesize
      dbuf[0, dsize].should eq buf
    end
  end

  it "Decompress zstd compressed file" do
    File.open "#{__DIR__}/../data/foo.9.txt.zstd" do |fio|
      Zstd::Decompress::IO.open fio do |cio|
        buf = cio.gets_to_end
        buf[0, 6].should eq "foobaz"
      end
    end
  end
end
