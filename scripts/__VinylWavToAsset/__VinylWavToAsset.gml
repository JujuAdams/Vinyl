function __VinylWavToAsset(_path)
{
    var _buffer = undefined;
    var _asset  = undefined;
    
    try
    {
        _buffer = buffer_load(_path);
        
    	// Check RIFF header
    	var _chunkID = buffer_peek(_buffer, 0, buffer_u32);
    	if (_chunkID != 0x46464952) throw "RIFF header not found for \"" + _path + "\"";
	    
    	var _signature = buffer_peek(_buffer, 8, buffer_u32);
    	if (_signature != 0x45564157) throw "WAVE header not found for \"" + _path + "\"";
        
    	if ((buffer_peek(_buffer, 12, buffer_u8) != 0x66) || (buffer_peek(_buffer, 13, buffer_u8) != 0x6D) || (buffer_peek(_buffer, 14, buffer_u8) != 0x74) || (buffer_peek(_buffer, 15, buffer_u8) != 0x20))
        {
            throw "fmt header not found for \"" + _path + "\"";
        }
        
    	switch(buffer_peek(_buffer, 22, buffer_u16))
        {
    		case 1: var _channel = audio_mono;   break;    
    		case 2: var _channel = audio_stereo; break;
            
    		default:
                throw "Channel count " + string(_channel) + " not supported for \"" + _path + "\"";
            break;
    	}
		
    	var _rate          = buffer_peek(_buffer, 24, buffer_u32);
    	var _bitsPerSample = buffer_peek(_buffer, 34, buffer_u16);
		
    	switch(_bitsPerSample)
        {
    		case  8: _bitsPerSample = buffer_u8;  break;
    		case 16: _bitsPerSample = buffer_s16; break;
            
    		default:
                throw "Bits-per-sample " + string(_bitsPerSample) + " not supported for \"" + _path + "\"";
            break;
    	}
	    
    	//Skip LIST-INFO
    	var _i = 0;
    	while(buffer_peek(_buffer, 36 + _i, buffer_u32) != 0x61746164)
        {
    		++_i; 
    	}
        
    	var _subchunkSize = buffer_peek(_buffer, 40 + _i, buffer_u32);
    	_asset = audio_create_buffer_sound(_buffer, _bitsPerSample, _rate, 42 + _i, _subchunkSize, _channel);
    }
    catch(_error)
    {
        __VinylReportError(_error, _path, false);
    }
    finally
    {
        if ((_buffer != undefined) && (_buffer >= 0)) buffer_delete(_buffer);
    }
    
    return _asset;
}