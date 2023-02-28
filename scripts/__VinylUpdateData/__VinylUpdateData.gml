function __VinylUpdateData()
{
    static _globalData = __VinylGlobalData();
    
    static _fileHash       = undefined;
    static _animCurveIndex = 0;
    var _firstUpdate = (_fileHash == undefined);
    
    //Always allow data to be updated once on boot
    if (!_globalData.__liveUpdate && (_fileHash != undefined)) return;
    
    var _filename = __VinylGetDatafilePath();
    
    if (__VinylGetLiveUpdateEnabled())
    {
        if (!file_exists(_filename))
        {
            __VinylError("Could not find \"", _filename, "\"\n- Ensure that \"", __VINYL_CONFIG_NOTE_NAME, "\" exists as a Notes asset in your project\n- Turn on the \"Disable file system sandbox\" game option for this platform");
            return;
        }
        
        var _foundHash = md5_file(_filename);
        if (_foundHash == _fileHash) return false;
        _fileHash = _foundHash;
    }
    else
    {
        //Only load once in non-live update mode
        if (_fileHash != undefined) return false;
        
        var _filename = __VINYL_DATA_BUNDLE_FILENAME;
        var _foundHash = "loaded";
    }
    
    var _success = undefined;
    var _t = get_timer();
    
    try
    {
        var _buffer = buffer_load(_filename);
        try
        {
            var _data = __VinylBufferReadLooseJSON(_buffer, 0);
            __VinylTrace("Read config in plaintext");
        }
        catch(_error)
        {
            buffer_seek(_buffer, buffer_seek_start, 0);
            var _string = buffer_read(_buffer, buffer_text);
            buffer_delete(_buffer);
            _buffer = buffer_base64_decode(_string);
            var _data = __VinylBufferReadLooseJSON(_buffer, 0);
            
            __VinylTrace("Read config in base64");
        }
        
        _success = true;
        __VinylTrace("Loaded data in ", (get_timer() - _t)/1000, "ms");
        
        var _t = get_timer();
        VinylSystemReadConfig(_data);
        __VinylTrace("Read data in ", (get_timer() - _t)/1000, "ms");
    }
    catch(_error)
    {
        show_debug_message("");
        __VinylTrace("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        __VinylTrace("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        __VinylTrace(_error.longMessage);
        __VinylTrace(_error.stacktrace);
        __VinylTrace("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        __VinylTrace("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        show_debug_message("");
        
        if (_firstUpdate)
        {
            __VinylError("There was an error whilst reading \"", _filename, "\"\n- Check the file contains valid JSON\n- Check that the config meets Vinyl's requirements\n- Check the nature of error by reading the output log");
        }
        else
        {
            __VinylTrace("There was an error whilst reading \"", _filename, "\"\n- Check the file contains valid JSON\n- Check that the config meets Vinyl's requirements\n- Check the nature of error by reading the output log");
        }
    }
    finally
    {
        buffer_delete(_buffer);
    }
    
    return _success;
}