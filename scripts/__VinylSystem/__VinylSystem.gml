// Feather disable all
#macro __VINYL_VERSION  "5.5.1"
#macro __VINYL_DATE     "2023-11-09"

#macro __VINYL_DATA_BUNDLE_FILENAME  "vinyl.dat"
#macro __VINYL_CONFIG_NOTE_NAME      "TestConfig"

#macro __VINYL_DOCUMENT_FILENAME  "VinylDocument.json"

#macro __VINYL_USE_GAIN_CURVE  true

#macro __VINYL_FALLOFF_MODEL  audio_falloff_exponent_distance_scaled

#macro __VINYL_RETURN_SELF_TO_POOL  if (__pool != undefined) { __pool.__Return(self) }

#macro __VINYL_ASSET_NULL  "<None>"

#macro __VINYL_OPTION_UNSET      "Unset"
#macro __VINYL_OPTION_MULTIPLY   "Multiply"
#macro __VINYL_OPTION_RANDOMIZE  "Randomize"
#macro __VINYL_OPTION_KNOB       "Knob"
#macro __VINYL_OPTION_OVERRIDE   "Override"
#macro __VINYL_OPTION_ADD        "Add"

#macro __VINYL_FALLBACK_NAME  "Fallback"

#macro __VINYL_PATTERN_TYPE_FALLBACK  "Fallback"
#macro __VINYL_PATTERN_TYPE_SOUND     "Sound"
#macro __VINYL_PATTERN_TYPE_BASIC     "Basic"
#macro __VINYL_PATTERN_TYPE_SHUFFLE   "Shuffle"
#macro __VINYL_PATTERN_TYPE_QUEUE     "Queue"
#macro __VINYL_PATTERN_TYPE_MULTI     "Multi"

#macro __VINYL_QUEUE_PLAY_ONCE    "Play Once"
#macro __VINYL_QUEUE_REPEAT_ALL   "Replay Whole Queue"
#macro __VINYL_QUEUE_REPEAT_LAST  "Replay Last Child"

enum __VINYL_SOUND_TYPE {
    __UNKNOWN,
    __WAD,
    __EXTERNAL_WAV,
    __EXTERNAL_OGG,
}


__VinylInitialize();

function __VinylInitialize()
{
    static _initialized = false;
    if (_initialized) return;
    _initialized = true;
    
    __VinylTrace("Welcome to Vinyl! This is version ", __VINYL_VERSION, ", ", __VINYL_DATE);
    
    __VinylValidateMacros();
    
    var _globalData = __VinylGlobalData();
    if (VINYL_DEBUG_LEVEL > 0) global.vinyl = _globalData;
    
    _globalData.__poolSound.__Populate(VINYL_POOL_START_SIZE);
    _globalData.__poolBasic.__Populate(VINYL_POOL_START_SIZE);
    _globalData.__poolQueue.__Populate(VINYL_POOL_START_SIZE);
    _globalData.__poolMulti.__Populate(VINYL_POOL_START_SIZE);
    _globalData.__poolEmitter.__Populate(VINYL_POOL_START_SIZE);
    _globalData.__poolPanEmitter.__Populate(VINYL_POOL_START_SIZE);
    
    if (!file_exists(__VINYL_DATA_BUNDLE_FILENAME))
    {
        __VinylError("Could not find \"", __VINYL_DATA_BUNDLE_FILENAME, "\"\n- Ensure that \"", __VINYL_DATA_BUNDLE_FILENAME, "\" has been added to your project's Included Files");
        return;
    }
    
    //Set up default behaviours within GM's audio system
    audio_falloff_set_model(__VINYL_FALLOFF_MODEL);
    audio_listener_set_orientation(VINYL_LISTENER_INDEX,   0, 0, 1,   0, -1, 0);
    audio_listener_set_position(VINYL_LISTENER_INDEX,   0, 0, 0);
    
    __ImGuiBoot();
    __VinylEditorInit();
    
    VinylSystemGainSet(1);
    __VinylEffectChainEnsure("main");
    
    _globalData.__document = new __VinylClassDocument(__VinylGetDocumentPath());
    
    //time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, __VinylTick, [], -1));
}

function __VinylTrace()
{
    static _globalData = __VinylGlobalData();
    
    if (VINYL_DEBUG_SHOW_FRAMES)
    {
        var _string = "Vinyl fr." + string(_globalData.__frame) + ": ";
    }
    else
    {
        var _string = "Vinyl: ";
    }
    
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

function __VinylGetRunningFromIDE()
{
    static _result = (GM_build_type == "run");
    return _result;
}

function __VinylGetEditorEnabled()
{
    static _result = undefined;
    if (_result == undefined)
    {
        _result = (VINYL_EDITOR_ENABLED && __VinylGetRunningFromIDE() && (os_type == os_windows));
    }
    
    return _result;
}

function __VinylGetLiveUpdateEnabled()
{
    static _result = undefined;
    if (_result == undefined)
    {
        _result = ((VINYL_LIVE_UPDATE_PERIOD > 0) && __VinylGetRunningFromIDE() && ((os_type == os_windows) || (os_type == os_macosx) || (os_type == os_linux)));
    }
    
    return _result;
}

function __VinylGetDocumentPath()
{
    static _result = undefined;
    if (_result == undefined)
    {
        if (__VinylGetEditorEnabled())
        {
            _result = filename_dir(GM_project_filename) + "/" + __VINYL_DOCUMENT_FILENAME;
        }
        else
        {
            _result = __VINYL_DATA_BUNDLE_FILENAME;
        }
    }
    
    return _result;
}