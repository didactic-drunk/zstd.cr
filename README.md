# zstd
[![Crystal CI](https://github.com/didactic-drunk/zstd.cr/actions/workflows/crystal.yml/badge.svg)](https://github.com/didactic-drunk/zstd.cr/actions/workflows/crystal.yml)
[![GitHub release](https://img.shields.io/github/release/didactic-drunk/zstd.cr.svg)](https://github.com/didactic-drunk/zstd.cr/releases)
![GitHub commits since latest release (by date) for a branch](https://img.shields.io/github/commits-since/didactic-drunk/zstd.cr/latest)
[![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://didactic-drunk.github.io/zstd.cr/main)

Crystal bindings to the Zstandard (zstd) compression library

## Features
- [x] Performance optimized.  20M small decompression messages/sec.
- [x] All API calls allow reusable buffers to reduce GC overhead.
- [x] No heap allocations after #initialize.
- [x] Crystal IO compatible Streaming API.
- [x] Snappy like buffer API for handling small messages.
- [x] `export ZSTD_CLEVEL=1` sets the default compression level just like the zstd command line utilities.
- [x] Only require what you need for faster compilation. (require "zstd/compress/context")

## Experimental Features.  API's subject to change.
- [x] Custom dictionaries.

## Todo
- [x] Linux: Auto install the most recent zstd if the system library is old or unavailable.
- [ ] OSX: Auto install the most recent zstd if the system library is old or unavailable.
- [ ] Support more zstd params.
- [ ] More specs.

## Installation

0. On **OSX** ensure that zstd is installed (`brew install zstd`).  
   On Linux it will be downloaded and compiled automatically if missing.

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

### Buffer API

```crystal
cctx = Zstd::Compress::Context.new(level: 1)
cbuf = cctx.compress buf

dctx = Zstd::Decompress::Context.new
dbuf = dctx.decompress cbuf
```

### Streaming API

```crystal
buf = Bytes.new 5
mio = IO::Memory.new
Zstd::Compress::IO.open(mio, level: 1) do |cio|
  cio.write buf
end

mio.rewind
str = Zstd::Decompress::IO.open(mio) do |dio|
  dio.gets_to_end
end
```

### Dictionary API
```
dict_buffer = File.read("dictionary").to_slice
dict = Zstd::Dict.new dict_buffer, level: 3

cctx = Zstd::Compress::Context.new dict: dict
dctx = Zstd::Decompress::Context.new dict: dict

# Compress or decompress using the Buffer or Streaming API's

p dict.dict_id
p dict.memsize
```

## Contributing

1. Fork it (<https://github.com/your-github-user/zstd/fork>)
2. **Install a formatting check git hook (ln -sf ../../scripts/git/pre-commit .git/hooks)**
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

## Contributors

- [Didactic Drunk](https://github.com/didactic-drunk) - creator and maintainer
