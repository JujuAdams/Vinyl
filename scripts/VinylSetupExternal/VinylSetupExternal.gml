// Feather disable all

/// @param path
/// @param [patternName=filename]
/// @param [gain=1]
/// @param [pitch=1]
/// @param [loop]
/// @param [mix=VINYL_DEFAULT_MIX]
/// @param [duckerName]
/// @param [duckPriority=0]
/// @param [emitterAlias]
/// @param [metadata]
/// @param [forceType]

function VinylSetupExternal(_path, _inPatternName = undefined, _gain = 1, _pitch = 1, _loop = undefined, _mixName = VINYL_DEFAULT_MIX, _duckerName = undefined, _duckPrio = undefined, _emitterAlias = undefined, _metadata = undefined, _filetype = undefined)
{
    static _system      = __VinylSystem();
    static _patternDict = _system.__patternDict;
    static _soundDict   = _system.__soundDict;
    
    if (not file_exists(_path))
    {
        __VinylError("Could not find \"", _path, "\"");
        return undefined;
    }
    
    if (_mixName == VINYL_NO_MIX) _mixName = undefined;
    var _patternName = _inPatternName ?? filename_name(_path);
    
    var _existingPattern = _patternDict[$ _patternName];
    if (_existingPattern != undefined)
    {
        //TODO - Update sound maybe?
        _existingPattern.__UpdateSetup(_gain, _pitch, _loop, _mixName, _duckerName, _duckPrio, _emitterAlias, _metadata);
        var _sound = _existingPattern.__sound;
    }
    else
    {
        var _buffer = buffer_load(_path);
        if (_buffer < 0)
        {
            __VinylError("Failed to load \"", _path, "\"");
            return undefined;
        }
        
        //Determine filetype by reading the magic number in the header
        if (_filetype == undefined)
        {
            var _header = buffer_read(_buffer, buffer_u32);
            if (_header == 0x46464952) //RIFF
            {
                _filetype = 1;
            }
            else if (_header == 0x5367674f) //OggS
            {
                _filetype = 2;
                buffer_delete(_buffer); //Don't this any more
            }
            else
            {
                __VinylError("Could not determine file type (header was not \"WAVE\" or \"OggS\", was 0x", string_delete(string(ptr(_header)), 1, 8), ")");
                return undefined;
            }
        }
        
        if (_filetype == 1) //WAV file
        {
            var _result      = __VinylSetupExternalLoadWAV(_path, _buffer); //Why does GameMaker not have a native WAV loader?
            var _sound       = _result.__sound;
            var _fixedBuffer = _result.__buffer;
            
            buffer_delete(_buffer);
            
            if (not audio_exists(_sound))
            {
                __VinylError("Could not generate audio handle for \"", _path, "\"");
                return -1;
            }
            
            var _pattern = new __VinylClassPatternExternalWAV(_fixedBuffer, _path, _inPatternName, _sound, _gain, _pitch, _loop, _mixName, _duckerName, _duckPrio, _emitterAlias, _metadata);
        }
        else if (_filetype == 2) //OGG file
        {
            var _sound = audio_create_stream(_path);
            
            if (not audio_exists(_sound))
            {
                __VinylError("Could not generate audio handle for \"", _path, "\"");
                return -1;
            }
            
            var _pattern = new __VinylClassPatternExternalOGG(_path, _inPatternName, _sound, _gain, _pitch, _loop, _mixName, _duckerName, _duckPrio, _emitterAlias, _metadata);
        }
        
        _patternDict[$ _patternName] = _pattern;
        struct_set_from_hash(_soundDict, int64(_sound), _pattern);
    }
    
    if (VINYL_LIVE_EDIT && (not _system.__importingJSON))
    {
        __VinylResolveChanges(false);
    }
    
    return _sound;
}

function __VinylSetupExternalLoadWAV(_path, _buffer = undefined)
{
    static _result = {
        __sound:  undefined,
        __buffer: undefined,
    };
    
    with(_result)
    {
        __sound  = undefined;
        __buffer = undefined;
    }
    
    buffer_seek(_buffer, buffer_seek_start, 0);
    var _size = buffer_get_size(_buffer);
    
    var _chunkID        = buffer_read(_buffer, buffer_u32);
    var _chunkSize      = buffer_read(_buffer, buffer_u32);
    var _chunkFormat    = buffer_read(_buffer, buffer_u32);
    var _subchunk1ID    = buffer_read(_buffer, buffer_u32);
    var _subchunk1Size  = buffer_read(_buffer, buffer_u32);
    var _audioFormat    = buffer_read(_buffer, buffer_u16);
    var _channels       = buffer_read(_buffer, buffer_u16);
    var _sampleRate     = buffer_read(_buffer, buffer_u32);
    var _byteRate       = buffer_read(_buffer, buffer_u32);
    var _blockAlignment = buffer_read(_buffer, buffer_u16);
    var _bitsPerSample  = buffer_read(_buffer, buffer_u16);
    var _subchunk2ID    = buffer_read(_buffer, buffer_u32);
    var _subchunk2Size  = buffer_read(_buffer, buffer_u32);
    
    if (_chunkFormat != 0x45564157) //WAVE, or 1163280727 in decimal‬
    {
        __VinylError("Chunk format not recognised");
        return _result;
    }
    
    if (_bitsPerSample == 8)
    {
        var _dataFormat = buffer_u8;
    }
    else if (_bitsPerSample == 16)
    {
        var _dataFormat = buffer_s16;
    }
    else
    {
        __VinylError(_bitsPerSample, " bits per sample is unsupported");
        return _result;
    }
    
    if (_blockAlignment != buffer_sizeof(_dataFormat))
    {
        __VinylError("Mismatch between block alignment (", _blockAlignment, ") and data format (", buffer_sizeof(_dataFormat));
        return _result;
    }
    
    var _channels = (_channels == 1)? audio_mono : audio_stereo;
    
    var _fixedBuffer = buffer_create(_subchunk2Size, buffer_fixed, 1);
    buffer_copy(_buffer, buffer_tell(_buffer), _subchunk2Size, _fixedBuffer, 0);
    
    var _sound = audio_create_buffer_sound(_fixedBuffer, _dataFormat, _sampleRate, 0, _subchunk2Size, _channels);
    
    if (not audio_exists(_sound))
    {
        __VinylError("Could not generate audio handle for \"", _path, "\"");
    }
    
    _result.__sound  = _sound;
    _result.__buffer = _fixedBuffer;
    
    return _result;
}