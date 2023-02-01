#macro __VINYL_VERSION  "4.0.6 alpha"
#macro __VINYL_DATE     "2023-02-01"

#macro __VINYL_DATA_BUNDLE_FILENAME  "vinyl.dat"
#macro __VINYL_CONFIG_NOTE_NAME      "__VinylConfig"

#macro __VINYL_FORCE_EXPONENTIAL_CURVE  true

#macro __VINYL_PAN_WIDTH  100

enum __VINYL_POOL_STATE
{
    __POOLED,
    __PLAYING,
}



__VinylInitialize();

function __VinylInitialize()
{
    static _initialized = false;
    if (_initialized) return;
    _initialized = true;
    
    __VinylTrace("Welcome to Vinyl! This is version ", __VINYL_VERSION, ", ", __VINYL_DATE);
    
    __VinylValidateMacros();
    
    if (!file_exists(__VINYL_DATA_BUNDLE_FILENAME))
    {
        __VinylError("Could not find \"", __VINYL_DATA_BUNDLE_FILENAME, "\"\n- Ensure that \"", __VINYL_DATA_BUNDLE_FILENAME, "\" has been added to your project's Included Files");
        return;
    }
    
    //Set up default behaviours within GM's audio system
    audio_falloff_set_model(audio_falloff_exponent_distance_scaled);
    audio_listener_set_orientation(0,   0, 0, 1,   0, -1, 0);
    audio_listener_set_position(0,   0, 0, 0);
    
    //Whether to allow live update
    global.__vinylLiveUpdate = (VINYL_LIVE_UPDATE_PERIOD > 0);
    
    global.__vinylPatternDict = {};
    global.__vinylLabelDict   = {};
    global.__vinylLabelOrder  = [];
    
    global.__vinylIdToInstanceDict = ds_map_create();
    
    global.__vinylBasicPool       = [];
    global.__vinylBasicPlaying    = [];
    global.__vinylBasicPoolReturn = [];
    
    global.__vinylEmitterPool       = [];
    global.__vinylEmitterPoolReturn = [];
    
    global.__vinylTransposeSemitones = 0;
    
    global.__vinylListener = {
        x: 0,
        y: 0,
    };
    
    VinylSystemGainSet(1);
    __VinylUpdateData();
    
    if (__VinylGetLiveUpdateEnabled())
    {
        time_source_start(time_source_create(time_source_global, VINYL_LIVE_UPDATE_PERIOD/1000, time_source_units_seconds, __VinylUpdateData, [], -1));
    }
    else if (GM_build_type == "run")
    {
        __VinylTrace("Live update *not* enabled (VINYL_LIVE_UPDATE_PERIOD=", VINYL_LIVE_UPDATE_PERIOD, ")");
    }
    
    time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, __VinylTick, [], -1));
    
    //Pre-populate the instance and emitter pools
    repeat(VINYL_POOL_START_SIZE)
    {
        array_push(global.__vinylBasicPool, new __VinylClassBasicInstance());
    }
    
    repeat(VINYL_POOL_START_SIZE)
    {
        array_push(global.__vinylEmitterPool, audio_emitter_create());
    }
}

function __VinylUpdateData()
{
    static _fileHash = undefined;
    var _firstUpdate = (_fileHash == undefined);
    
    //Always allow data to be updated once on boot
    if (!global.__vinylLiveUpdate && (_fileHash != undefined)) return;
    
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
        __VinylTrace(_error);
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

function __VinylTrace()
{
    var _string = "Vinyl: ";
    
    var _i = 0
    repeat(argument_count)
    {
        _string += string(argument[_i]);
        ++_i;
    }
    
    show_debug_message(_string);
}

function __VinylError()
{
    var _string = "";
    
    var _i = 0
    repeat(argument_count)
    {
        _string += string(argument[_i]);
        ++_i;
    }
    
    show_debug_message("Vinyl " + __VINYL_VERSION + ": " + string_replace_all(_string, "\n", "\n             "));
    show_error("Vinyl:\n" + _string + "\n ", true);
}

function __VinylGetLiveUpdateEnabled()
{
    static _result = undefined;
    if (_result == undefined)
    {
        _result = ((VINYL_LIVE_UPDATE_PERIOD > 0) && (GM_build_type == "run") && ((os_type == os_windows) || (os_type == os_macosx) || (os_type == os_linux)));
    }
    
    return _result;
}

function __VinylGetDatafilePath()
{
    static _result = undefined;
    if (_result == undefined)
    {
        if (__VinylGetLiveUpdateEnabled())
        {
            _result = filename_dir(GM_project_filename) + "/notes/" + __VINYL_CONFIG_NOTE_NAME + "/" + __VINYL_CONFIG_NOTE_NAME + ".txt";
        }
        else
        {
            _result = __VINYL_DATA_BUNDLE_FILENAME;
        }
    }
    
    return _result;
}