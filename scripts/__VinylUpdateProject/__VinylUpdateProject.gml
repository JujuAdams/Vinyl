function __VinylUpdateProject()
{
    static _globalData     = __VinylGlobalData();
    static _projectFileHash = undefined;
    var _projectFileHashReflect = _projectFileHash;
    
    if ((not __VinylGetLiveUpdateEnabled()) || (GM_build_type != "run")) return;
    
    var _firstUpdate = (_projectFileHash == undefined);
    var _reloadProject = false;
    
    var _filename = GM_project_filename;
    if (!file_exists(_filename))
    {
        __VinylError("Could not find \"", _filename, "\"\n- Turn on the \"Disable file system sandbox\" game option for this platform");
        return;
    }
    
    var _foundHash = md5_file(_filename);
    if (_foundHash == _projectFileHash) return;
    _projectFileHash = _foundHash;
    
    var _success = undefined;
    var _t = get_timer();
    
    try
    {
        var _buffer = buffer_load(_filename);
        if (buffer_get_size(_buffer) <= 0) throw "File is empty";
        
        var _string = buffer_read(_buffer, buffer_string);
        var _data = json_parse(_string);
        __VinylSystemReadProject(_data, _firstUpdate);
        
        _success = true;
        __VinylTrace("Loaded project file in ", (get_timer() - _t)/1000, "ms");
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
        
        var _trimmedMessage = string_replace(_error.message, "Vinyl:\n", "");
        _trimmedMessage = string_copy(_trimmedMessage, 1, string_length(_trimmedMessage)-2);
        
        if (_firstUpdate)
        {
            __VinylError("There was an error whilst reading \"", _filename, "\"\n \n", _trimmedMessage);
        }
        else
        {
            _trimmedMessage = string_replace_all(_trimmedMessage, "\n", "\n       ");
            __VinylTrace("There was an error whilst reading \"", _filename, "\"");
            __VinylTrace(_trimmedMessage);
        }
    }
    finally
    {
        buffer_delete(_buffer);
    }
    
    return _success;
}