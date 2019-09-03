# zstd
[![Build Status](https://travis-ci.org/didactic-drunk/zstd.cr.svg?branch=master)](https://travis-ci.org/didactic-drunk/zstd.cr)
[![GitHub release](https://img.shields.io/github/release/didactic-drunk/zstd.cr.svg)](https://github.com/didactic-drunk/zstd.cr/releases)
[![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://didactic-drunk.github.io/zstd.cr/)

Crystal bindings to the Zstandard (zstd) compression library 

## Features
- [x] Performance optimized.  20M small decompression messages/sec.
- [x] All API calls allow reusable buffers to reduce GC overhead.
- [x] No heap allocations after #initialize.
- [x] Crystal IO compatible Streaming API.
- [x] Snappy like buffer API for handling small messages.
- [x] `export ZSTD_CLEVEL=1` sets the default compression level just like the zstd command line utilities.

## Todo
- [] Auto install the most recent zstd if the system library is old or unavailable.
- [] Custom dictionaries
- [] Support more zstd params.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     zstd:
       github: didactic-drunk/zstd.cr
   ```

2. Run `shards install`

## Usage

```crystal
require "zstd"
```

```
### Buffer API

```crystal
cctx = Zstd::Compress::Context.new(level: 1)
cbuf = cctx.compress buf

dctx = Zstd::Decompress::Context.new
dbuf = dctx.decompress cbuf, Bytes.new(buf.bytesize)
```

### Streaming API
```crystal
buf = Bytes.new 5
mio = IO::Memory.new
Zstd::Compress::IO.open(mio, level: 1) do |cio|
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
2. **Install a formatting check git hook (ln -sf ../../scripts/git/pre-commit .git/hooks)**
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

## Contributors

- [Didactic Drunk](https://github.com/didactic-drunk) - creator and maintainer
