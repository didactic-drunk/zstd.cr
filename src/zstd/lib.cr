module Zstd
  @[Link(ldflags: "`command -v pkg-config > /dev/null && pkg-config --libs zstd 2> /dev/null|| printf %s '-lzstd'`")]
  lib Lib
    ZSTD_BLOCKSIZELOG_MAX           =             17
    ZSTD_CLEVEL_DEFAULT             =              3
    ZSTD_MAGICNUMBER                = 4247762216_i64
    ZSTD_MAGIC_DICTIONARY           = 3962610743_i64
    ZSTD_MAGIC_SKIPPABLE_MASK       = 4294967280_i64
    ZSTD_MAGIC_SKIPPABLE_START      =      407710288
    ZSTD_VERSION_MAJOR              =              1
    ZSTD_VERSION_MINOR              =              4
    ZSTD_VERSION_RELEASE            =              0
    ZstdBtlazy2                     =          6_i64
    ZstdBtopt                       =          7_i64
    ZstdBtultra                     =          8_i64
    ZstdBtultra2                    =          9_i64
    ZstdCChainLog                   =        103_i64
    ZstdCChecksumFlag               =        201_i64
    ZstdCCompressionLevel           =        100_i64
    ZstdCContentSizeFlag            =        200_i64
    ZstdCDictIdFlag                 =        202_i64
    ZstdCEnableLongDistanceMatching =        160_i64
    ZstdCExperimentalParam1         =        500_i64
    ZstdCExperimentalParam2         =         10_i64
    ZstdCExperimentalParam3         =       1000_i64
    ZstdCExperimentalParam4         =       1001_i64
    ZstdCExperimentalParam5         =       1002_i64
    ZstdCHashLog                    =        102_i64
    ZstdCJobSize                    =        401_i64
    ZstdCLdmBucketSizeLog           =        163_i64
    ZstdCLdmHashLog                 =        161_i64
    ZstdCLdmHashRateLog             =        164_i64
    ZstdCLdmMinMatch                =        162_i64
    ZstdCMinMatch                   =        105_i64
    ZstdCNbWorkers                  =        400_i64
    ZstdCOverlapLog                 =        402_i64
    ZstdCSearchLog                  =        104_i64
    ZstdCStrategy                   =        107_i64
    ZstdCTargetLength               =        106_i64
    ZstdCWindowLog                  =        101_i64
    ZstdDExperimentalParam1         =       1000_i64
    ZstdDWindowLogMax               =        100_i64
    ZstdDfast                       =          2_i64
    ZstdEContinue                   =          0_i64
    ZstdEEnd                        =          2_i64
    ZstdEFlush                      =          1_i64
    ZstdFast                        =          1_i64
    ZstdGreedy                      =          3_i64
    ZstdLazy                        =          4_i64
    ZstdLazy2                       =          5_i64
    ZstdResetParameters             =          2_i64
    ZstdResetSessionAndParameters   =          3_i64
    ZstdResetSessionOnly            =          1_i64
    alias ZstdCCtxS = Void
    alias ZstdCDictS = Void
    alias ZstdCStream = ZstdCCtx
    alias ZstdDCtxS = Void
    alias ZstdDDictS = Void
    alias ZstdDStream = ZstdDCtx
    enum ZstdCParameter
      ZstdCCompressionLevel           =  100
      ZstdCWindowLog                  =  101
      ZstdCHashLog                    =  102
      ZstdCChainLog                   =  103
      ZstdCSearchLog                  =  104
      ZstdCMinMatch                   =  105
      ZstdCTargetLength               =  106
      ZstdCStrategy                   =  107
      ZstdCEnableLongDistanceMatching =  160
      ZstdCLdmHashLog                 =  161
      ZstdCLdmMinMatch                =  162
      ZstdCLdmBucketSizeLog           =  163
      ZstdCLdmHashRateLog             =  164
      ZstdCContentSizeFlag            =  200
      ZstdCChecksumFlag               =  201
      ZstdCDictIdFlag                 =  202
      ZstdCNbWorkers                  =  400
      ZstdCJobSize                    =  401
      ZstdCOverlapLog                 =  402
      ZstdCExperimentalParam1         =  500
      ZstdCExperimentalParam2         =   10
      ZstdCExperimentalParam3         = 1000
      ZstdCExperimentalParam4         = 1001
      ZstdCExperimentalParam5         = 1002
    end
    enum ZstdDParameter
      ZstdDWindowLogMax       =  100
      ZstdDExperimentalParam1 = 1000
    end
    enum ZstdEndDirective
      ZstdEContinue = 0
      ZstdEFlush    = 1
      ZstdEEnd      = 2
    end
    enum ZstdResetDirective
      ZstdResetSessionOnly          = 1
      ZstdResetParameters           = 2
      ZstdResetSessionAndParameters = 3
    end
    fun c_ctx_load_dictionary = ZSTD_CCtx_loadDictionary(cctx : ZstdCCtx, dict : Void*, dict_size : LibC::SizeT) : LibC::SizeT
    fun c_ctx_ref_c_dict = ZSTD_CCtx_refCDict(cctx : ZstdCCtx, cdict : ZstdCDict) : LibC::SizeT
    fun c_ctx_ref_prefix = ZSTD_CCtx_refPrefix(cctx : ZstdCCtx, prefix : Void*, prefix_size : LibC::SizeT) : LibC::SizeT
    fun c_ctx_reset = ZSTD_CCtx_reset(cctx : ZstdCCtx, reset : ZstdResetDirective) : LibC::SizeT
    fun c_ctx_set_parameter = ZSTD_CCtx_setParameter(cctx : ZstdCCtx, param : ZstdCParameter, value : LibC::Int) : LibC::SizeT

    fun c_ctx_get_parameter = ZSTD_CCtx_getParameter(cctx : ZstdCCtx, param : ZstdCParameter, value : LibC::Int*) : LibC::SizeT

    fun c_ctx_set_pledged_src_size = ZSTD_CCtx_setPledgedSrcSize(cctx : ZstdCCtx, pledged_src_size : LibC::ULongLong) : LibC::SizeT
    fun c_param_get_bounds = ZSTD_cParam_getBounds(c_param : ZstdCParameter) : ZstdBounds
    fun c_stream_in_size = ZSTD_CStreamInSize : LibC::SizeT
    fun c_stream_out_size = ZSTD_CStreamOutSize : LibC::SizeT
    fun compress = ZSTD_compress(dst : Void*, dst_capacity : LibC::SizeT, src : Void*, src_size : LibC::SizeT, compression_level : LibC::Int) : LibC::SizeT
    fun compress2 = ZSTD_compress2(cctx : ZstdCCtx, dst : Void*, dst_capacity : LibC::SizeT, src : Void*, src_size : LibC::SizeT) : LibC::SizeT
    fun compress_bound = ZSTD_compressBound(src_size : LibC::SizeT) : LibC::SizeT
    fun compress_c_ctx = ZSTD_compressCCtx(cctx : ZstdCCtx, dst : Void*, dst_capacity : LibC::SizeT, src : Void*, src_size : LibC::SizeT, compression_level : LibC::Int) : LibC::SizeT
    fun compress_stream = ZSTD_compressStream(zcs : ZstdCStream*, output : ZstdOutBuffer*, input : ZstdInBuffer*) : LibC::SizeT
    fun compress_stream2 = ZSTD_compressStream2(cctx : ZstdCCtx, output : ZstdOutBuffer*, input : ZstdInBuffer*, end_op : ZstdEndDirective) : LibC::SizeT
    fun compress_using_c_dict = ZSTD_compress_usingCDict(cctx : ZstdCCtx, dst : Void*, dst_capacity : LibC::SizeT, src : Void*, src_size : LibC::SizeT, cdict : ZstdCDict) : LibC::SizeT
    fun compress_using_dict = ZSTD_compress_usingDict(ctx : ZstdCCtx, dst : Void*, dst_capacity : LibC::SizeT, src : Void*, src_size : LibC::SizeT, dict : Void*, dict_size : LibC::SizeT, compression_level : LibC::Int) : LibC::SizeT
    fun create_c_ctx = ZSTD_createCCtx : ZstdCCtx
    fun create_c_dict = ZSTD_createCDict(dict_buffer : Void*, dict_size : LibC::SizeT, compression_level : LibC::Int) : ZstdCDict
    fun create_c_stream = ZSTD_createCStream : ZstdCStream*
    fun create_d_ctx = ZSTD_createDCtx : ZstdDCtx
    fun create_d_dict = ZSTD_createDDict(dict_buffer : Void*, dict_size : LibC::SizeT) : ZstdDDict
    fun create_d_stream = ZSTD_createDStream : ZstdDStream*
    fun d_ctx_load_dictionary = ZSTD_DCtx_loadDictionary(dctx : ZstdDCtx, dict : Void*, dict_size : LibC::SizeT) : LibC::SizeT
    fun d_ctx_ref_d_dict = ZSTD_DCtx_refDDict(dctx : ZstdDCtx, ddict : ZstdDDict) : LibC::SizeT
    fun d_ctx_ref_prefix = ZSTD_DCtx_refPrefix(dctx : ZstdDCtx, prefix : Void*, prefix_size : LibC::SizeT) : LibC::SizeT
    fun d_ctx_reset = ZSTD_DCtx_reset(dctx : ZstdDCtx, reset : ZstdResetDirective) : LibC::SizeT
    fun d_ctx_set_parameter = ZSTD_DCtx_setParameter(dctx : ZstdDCtx, param : ZstdDParameter, value : LibC::Int) : LibC::SizeT
    fun d_param_get_bounds = ZSTD_dParam_getBounds(d_param : ZstdDParameter) : ZstdBounds
    fun d_stream_in_size = ZSTD_DStreamInSize : LibC::SizeT
    fun d_stream_out_size = ZSTD_DStreamOutSize : LibC::SizeT
    fun decompress = ZSTD_decompress(dst : Void*, dst_capacity : LibC::SizeT, src : Void*, compressed_size : LibC::SizeT) : LibC::SizeT
    fun decompress_d_ctx = ZSTD_decompressDCtx(dctx : ZstdDCtx, dst : Void*, dst_capacity : LibC::SizeT, src : Void*, src_size : LibC::SizeT) : LibC::SizeT
    fun decompress_stream = ZSTD_decompressStream(zds : ZstdDStream*, output : ZstdOutBuffer*, input : ZstdInBuffer*) : LibC::SizeT
    fun decompress_using_d_dict = ZSTD_decompress_usingDDict(dctx : ZstdDCtx, dst : Void*, dst_capacity : LibC::SizeT, src : Void*, src_size : LibC::SizeT, ddict : ZstdDDict) : LibC::SizeT
    fun decompress_using_dict = ZSTD_decompress_usingDict(dctx : ZstdDCtx, dst : Void*, dst_capacity : LibC::SizeT, src : Void*, src_size : LibC::SizeT, dict : Void*, dict_size : LibC::SizeT) : LibC::SizeT
    fun end_stream = ZSTD_endStream(zcs : ZstdCStream*, output : ZstdOutBuffer*) : LibC::SizeT
    fun find_frame_compressed_size = ZSTD_findFrameCompressedSize(src : Void*, src_size : LibC::SizeT) : LibC::SizeT
    fun flush_stream = ZSTD_flushStream(zcs : ZstdCStream*, output : ZstdOutBuffer*) : LibC::SizeT
    fun free_c_ctx = ZSTD_freeCCtx(cctx : ZstdCCtx) : LibC::SizeT
    fun free_c_dict = ZSTD_freeCDict(c_dict : ZstdCDict) : LibC::SizeT
    fun free_c_stream = ZSTD_freeCStream(zcs : ZstdCStream*) : LibC::SizeT
    fun free_d_ctx = ZSTD_freeDCtx(dctx : ZstdDCtx) : LibC::SizeT
    fun free_d_dict = ZSTD_freeDDict(ddict : ZstdDDict) : LibC::SizeT
    fun free_d_stream = ZSTD_freeDStream(zds : ZstdDStream*) : LibC::SizeT
    fun get_decompressed_size = ZSTD_getDecompressedSize(src : Void*, src_size : LibC::SizeT) : LibC::ULongLong
    fun get_dict_id_from_d_dict = ZSTD_getDictID_fromDDict(ddict : ZstdDDict) : LibC::UInt
    fun get_dict_id_from_dict = ZSTD_getDictID_fromDict(dict : Void*, dict_size : LibC::SizeT) : LibC::UInt
    fun get_dict_id_from_frame = ZSTD_getDictID_fromFrame(src : Void*, src_size : LibC::SizeT) : LibC::UInt
    fun get_error_name = ZSTD_getErrorName(code : LibC::SizeT) : LibC::Char*
    fun get_frame_content_size = ZSTD_getFrameContentSize(src : Void*, src_size : LibC::SizeT) : LibC::ULongLong
    fun init_c_stream = ZSTD_initCStream(zcs : ZstdCStream*, compression_level : LibC::Int) : LibC::SizeT
    fun init_d_stream = ZSTD_initDStream(zds : ZstdDStream*) : LibC::SizeT
    fun is_error = ZSTD_isError(code : LibC::SizeT) : LibC::UInt
    fun max_c_level = ZSTD_maxCLevel : LibC::Int
    fun min_c_level = ZSTD_minCLevel : LibC::Int
    fun sizeof_c_ctx = ZSTD_sizeof_CCtx(cctx : ZstdCCtx) : LibC::SizeT
    fun sizeof_c_dict = ZSTD_sizeof_CDict(cdict : ZstdCDict) : LibC::SizeT
    fun sizeof_c_stream = ZSTD_sizeof_CStream(zcs : ZstdCStream*) : LibC::SizeT
    fun sizeof_d_ctx = ZSTD_sizeof_DCtx(dctx : ZstdDCtx) : LibC::SizeT
    fun sizeof_d_dict = ZSTD_sizeof_DDict(ddict : ZstdDDict) : LibC::SizeT
    fun sizeof_d_stream = ZSTD_sizeof_DStream(zds : ZstdDStream*) : LibC::SizeT
    fun version_number = ZSTD_versionNumber : LibC::UInt
    fun version_string = ZSTD_versionString : LibC::Char*

    struct ZstdBounds
      error : LibC::SizeT
      lower_bound : LibC::Int
      upper_bound : LibC::Int
    end

    struct ZstdInBufferS
      src : Void*
      size : LibC::SizeT
      pos : LibC::SizeT
    end

    struct ZstdOutBufferS
      dst : Void*
      size : LibC::SizeT
      pos : LibC::SizeT
    end

    type ZstdCCtx = Void*
    #  type ZstdCCtx = ZstdCCtxS
    type ZstdCDict = Void*
    type ZstdDCtx = Void*
    #  type ZstdDCtx = ZstdDCtxS
    type ZstdDDict = Void*
    type ZstdInBuffer = ZstdInBufferS
    type ZstdOutBuffer = ZstdOutBufferS
  end
end
