require "../spec_helper"
require "../../src/zstd/dict"

TEST_DICT_BUF = File.read("#{__DIR__}/../data/test.9.dictionary").to_slice

describe Zstd::Dict do
  it "Can't decompress without the correct dictionary" do
    dict = Zstd::Dict.new TEST_DICT_BUF, 9
    cctx = Zstd::Compress::Context.new dict: dict
    dctx = Zstd::Decompress::Context.new

    cbuf = cctx.compress "foo".to_slice
    expect_raises Zstd::Decompress::Context::Error, /Dictionary mismatch/ do
      dctx.decompress cbuf
    end

    dctx = Zstd::Decompress::Context.new dict: dict
    dctx.decompress cbuf
  end

  it "Test dict_id and memsize" do
    dict = Zstd::Dict.new TEST_DICT_BUF, 9

    dict_id = dict.dict_id
    dict_id.should_not eq 0

    ms = dict.memsize
    ms.should be > 0

    dict.cdict
    cms = dict.memsize
    cms.should be > ms # Memsize grows as dicts are lazily loaded.

    dict.ddict.dict_id.should eq dict_id
    dms = dict.memsize
    dms.should be > cms # Memsize grows as dicts are lazily loaded.
  end
end
