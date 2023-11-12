// Feather disable all

/// @param type
/// @param name
/// @param yyPath
/// @param absolutePath

function __VinylClassProjectSound(_type, _name, _yyPath, _absolutePath) constructor
{
    __type         = _type;
    __name         = _name;
    __yyPath       = _yyPath;
    __absolutePath = _absolutePath;
    
    __soundID = undefined;
    
    __compiledValues     = undefined;
    __compiledAudioGroup = undefined;
    __compiledAttributes = undefined;
    __audioGroup         = undefined;
    __attributes         = undefined;
    
    __yyHash = undefined;
    
    __Load();
    
    static __Load = function()
    {
        switch(__type)
        {
            case __VINYL_SOUND_TYPE.__WAD:
                __soundID = asset_get_index(__name);
            break;
            
            case __VINYL_SOUND_TYPE.__EXTERNAL_WAV:
                var _growBuffer = buffer_load(__absolutePath);
                
                //Do some silly shit to make the loaded buffer into a "fixed" buffer rather than the default "grow" buffer
                __buffer = buffer_create(buffer_get_size(_growBuffer), buffer_fixed, 1);
                buffer_copy(_growBuffer, 0, buffer_get_size(_growBuffer), __buffer, 0);
                buffer_delete(_growBuffer);
                
                //Read the .wav header
                var _chunk_id        = buffer_read(__buffer, buffer_u32);
                var _chunk_size      = buffer_read(__buffer, buffer_u32);
                var _chunk_format    = buffer_read(__buffer, buffer_u32);
                var _subchunk1_id    = buffer_read(__buffer, buffer_u32);
                var _subchunk1_size  = buffer_read(__buffer, buffer_u32);
                var _audio_format    = buffer_read(__buffer, buffer_u16);
                var _channels        = buffer_read(__buffer, buffer_u16);
                var _sample_rate     = buffer_read(__buffer, buffer_u32);
                var _byte_rate       = buffer_read(__buffer, buffer_u32);
                var _block_alignment = buffer_read(__buffer, buffer_u16);
                var _bits_per_sample = buffer_read(__buffer, buffer_u16);
                var _subchunk2_id    = buffer_read(__buffer, buffer_u32);
                var _subchunk2_size  = buffer_read(__buffer, buffer_u32);
    
                __VinylTrace("Making sound ID for .wav file \"", __absolutePath, "\" (chunk format=", _chunk_format, ", format=", _audio_format, ", channels=", _channels, ", sample rate=", _sample_rate, ", bitrate=", _byte_rate, ", bitdepth=", _bits_per_sample, ", size=", _subchunk2_size, ")");
    
                if (_chunk_format != 0x45564157) //WAVE, or 1163280727 in decimal‬
                {
                    __VinylError("Chunk format not recognised");
                    buffer_delete(__buffer);
                    return -1;
                }
    
                switch(_bits_per_sample)
                {
                    case 8:  var _data_format = buffer_u8;  break;
                    case 16: var _data_format = buffer_s16; break;
                    default:
                        __VinylError(_bits_per_sample, " bits per sample is unsupported");
                        buffer_delete(__buffer);
                        return -1;
                    break;
                }
    
                if (_block_alignment != _channels*buffer_sizeof(_data_format))
                {
                    __VinylError("Mismatch between block alignment (", _block_alignment, ") and data format (", buffer_sizeof(_data_format), ")");
                    buffer_delete(__buffer);
                    return -1;
                }   

                var _channels = (_channels == 1)? audio_mono : audio_stereo;
                __soundID = audio_create_buffer_sound(__buffer, _data_format, _sample_rate, buffer_tell(__buffer), _subchunk2_size, _channels);
            break;
            
            case __VINYL_SOUND_TYPE.__EXTERNAL_OGG:
                __soundID = audio_create_stream(__absolutePath);
            break;
        }
        
        __VinylTrace("Loaded \"", __name, "\" type ", __type, " as sound ID <", __soundID, "> (path=", __absolutePath, ")");
    }
    
    static __Unload = function()
    {
        if (__soundID == undefined) return;
        if (__type == __VINYL_SOUND_TYPE.__WAD) return;
        
        __Stop();
        
        __VinylTrace("Unloading \"", __name, "\" type ", __type, " sound ID <", __soundID, "> (path=", __absolutePath, ")");
        
        switch(__type)
        {
            case __VINYL_SOUND_TYPE.__EXTERNAL_WAV:
                audio_free_buffer_sound(__soundID);
                
                buffer_delete(__buffer);
                __buffer = undefined;
            break;
            
            case __VINYL_SOUND_TYPE.__EXTERNAL_OGG:
                audio_destroy_stream(__soundID);
            break;
        }
        
        __soundID = undefined;
    }
    
    static __Stop = function()
    {
        if (__soundID == undefined) return;
        
        __VinylTrace("Stopping \"", __name, "\" sound ID <", __soundID, "> (path=", __absolutePath, ")");
        audio_stop_sound(__soundID);
    }
    
    static __Change = function(_newType, _newName, _newAbsolutePath)
    {
        __VinylTrace("Renaming \"", __name, "\" type ", __type, " (path=", __absolutePath, ") to \"", _newName, "\" type ", _newType, " (path=", _newAbsolutePath, ")");
        
        __Stop();
        
        var _oldType = __type;
        if (_oldType == __VINYL_SOUND_TYPE.__EXTERNAL_OGG)
        {
            //Always destroy audio streams due to the filename change
            __Unload();
        }
        
        __type         = _newType;
        __name         = _newName;
        __absolutePath = _newAbsolutePath;
        
        if ((_oldType == __VINYL_SOUND_TYPE.__WAD) || (_newType == __VINYL_SOUND_TYPE.__EXTERNAL_OGG))
        {
            //If we weren't using an external file before, reload
            //Also, if the new type is an audio stream then reload too
            __Load();
        }
        else
        {
            __VinylTrace("Sound ID for \"", __name, "\" remains <", __soundID, ">");
        }
    }
    
    static __SetAudioGroup = function(_newAudioGroup)
    {
        if (__audioGroup == _newAudioGroup) return;
        
        var _buffer = buffer_load(__yyPath);
        var _fileString = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        var _searchString1 = "\"name\": \"" + __audioGroup + "\"";
        var _searchString2 = "\"path\": \"audiogroups/" + __audioGroup + "\"";
        
        var _pos = string_pos(_searchString1, _fileString);
        if (_pos < 0)
        {
            __VinylTrace("Warning! Could not find audio group \"", __audioGroup, "\" in \"", __yyPath, "\" (first check)");
            return;
        }
        
        var _pos = string_pos(_searchString2, _fileString);
        if (_pos < 0)
        {
            __VinylTrace("Warning! Could not find audio group \"", __audioGroup, "\" in \"", __yyPath, "\" (second check)");
            return;
        }
        
        _fileString = string_replace(_fileString, _searchString1, "\"name\": \"" + _newAudioGroup + "\"");
        _fileString = string_replace(_fileString, _searchString2, "\"path\": \"audiogroups/" + _newAudioGroup + "\"");
        
        var _buffer = buffer_create(string_byte_length(_fileString), buffer_fixed, 1);
        buffer_write(_buffer, buffer_text, _fileString);
        buffer_save(_buffer, __yyPath);
        buffer_delete(_buffer);
        
        __audioGroup = _newAudioGroup;
    }
    
    static __SetAttributes = function(_newAttributes)
    {
        if (__attributes == _newAttributes) return;
        
        var _buffer = buffer_load(__yyPath);
        var _fileString = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        var _searchString = "\"compression\": " + string(__attributes);
        
        var _pos = string_pos(_searchString, _fileString);
        if (_pos < 0)
        {
            __VinylTrace("Warning! Could not find attribute ", __attributes, " in \"", __yyPath, "\"");
            return;
        }
        
        _fileString = string_replace(_fileString, _searchString, "\"compression\": " + string(_newAttributes));
        
        var _buffer = buffer_create(string_byte_length(_fileString), buffer_fixed, 1);
        buffer_write(_buffer, buffer_text, _fileString);
        buffer_save(_buffer, __yyPath);
        buffer_delete(_buffer);
        
        __attributes = _newAttributes;
    }
    
    static __CheckYYFile = function(_firstUpdate)
    {
        var _hash = md5_file(__yyPath);
        if (_hash != __yyHash)
        {
            __yyHash = _hash;
            
            var _buffer = buffer_load(__yyPath);
            var _string = buffer_read(_buffer, buffer_text);
            buffer_delete(_buffer);
            var _soundJSON = json_parse(_string);
            
            __audioGroup = _soundJSON.audioGroupId.name;
            __attributes = _soundJSON.compression;
            
            if (__compiledValues == undefined)
            {
                __compiledValues = _firstUpdate;
                
                if (__compiledValues)
                {
                    __compiledAudioGroup = __audioGroup;
                    __compiledAttributes = __attributes;
                }
            }
        }
    }
}