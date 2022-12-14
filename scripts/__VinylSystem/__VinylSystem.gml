#macro __VINYL_VERSION  "0.0.0"
#macro __VINYL_DATE     "2022-12-13"

#macro __VINYL_DATA_BUNDLE_FILENAME  "vinyl.dat"
#macro __VINYL_CONFIG_NOTE_NAME      "__VinylConfig"

__VinylInitialize();

function __VinylInitialize()
{
    static _initialized = false;
    if (_initialized) return;
    _initialized = true;
    
    __VinylTrace("Welcome to Vinyl! This is version ", __VINYL_VERSION, ", ", __VINYL_DATE);
    
    global.__vinylLiveUpdate = (VINYL_LIVE_UPDATE_PERIOD > 0);
    
    global.__vinylData = undefined;
    
    global.__vinylPlaying   = [];
	global.__vinylInstances = ds_map_create();
    global.__vinylPool      = array_create(VINYL_STARTING_POOL_SIZE, undefined);
	
    var _i = 0;
    repeat(VINYL_STARTING_POOL_SIZE)
    {
        global.__vinylPool[@ _i] = new __VinylClassInstance();
        ++_i;
    }
    
	VinylSystemGain(0);
    __VinylUpdateData();
    
    if (__VinylGetLiveUpdateEnabled())
    {
        time_source_start(time_source_create(time_source_global, VINYL_LIVE_UPDATE_PERIOD, time_source_units_frames, __VinylUpdateData, [], -1));
    }
    else if (GM_build_type == "run")
    {
        __VinylTrace("Live update *not* enabled");
    }
}

function __VinylUpdateData()
{
    static _fileHash = undefined;
	
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
        if (!file_exists(_filename))
        {
            __VinylError("Could not find \"", _filename, "\"\n- Ensure that \"", __VINYL_DATA_BUNDLE_FILENAME, "\" has been added to your project's Included Files");
            return;
        }
        
        var _foundHash = "loaded";
    }
    
    var _success = undefined;
    var _t = get_timer();
    
    try
    {
        var _buffer = buffer_load(_filename);
        global.__vinylData = SnapBufferReadYAML(_buffer, 0);
        
        _success = true;
        __VinylTrace("Loaded data in ", (get_timer() - _t)/1000, "ms");
    }
    catch(_error)
    {
        show_debug_message(_error);
        
        if (global.__vinylData == undefined)
        {
            __VinylError("There was an error whilst reading \"", _filename, "\"\nPlease check it is valid YAML");
        }
        else
        {
            __VinylTrace("There was an error whilst reading \"", _filename, "\". Please check it is valid YAML");
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
        if (is_real(argument[_i]))
        {
            _string += string_format(argument[_i], 0, 4);
        }
        else
        {
            _string += string(argument[_i]);
        }
        
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