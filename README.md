# zstd

Crystal bindings to the Zstandard (zstd) compression library 

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     zstd:
       github: didactic-drunk/zstd.cr
   ```

2. Run `shards install`

## Usage

### Buffer API
```crystal
require "zstd"

cctx = Zstd::Compress::Context.new
cctx.compression_level = 1
cbuf = cctx.compress buf

dctx = Zstd::Decompress::Context.new
dbuf = dctx.decompress cbuf, Bytes.new(buf.bytesize)
```

### Streaming API
```crystal
buf = Bytes.new 5
mio = IO::Memory.new
Zstd::Compress::IO.open(mio) do |cio|
  cio.compression_level = 1
  cio.write buf
end

cbuf = mio.to_slice

mio = IO::Memory.new cbuf
dbuf = Zstd::Decompress::IO.open(mio) do |dio|
  tbuf = Bytes.new buf.bytesize * 2
  tsize = dio.read dbuf
  tbuf[0, tsize]
end

# dbuf.should eq buf
```


## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/your-github-user/zstd/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Didactic Drunk](https://github.com/didactic-drunk) - creator and maintainer
