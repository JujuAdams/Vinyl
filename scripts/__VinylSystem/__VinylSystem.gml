// Feather disable all

#macro __VINYL_VERSION  "6.0.0"
#macro __VINYL_DATE     "2024-03-14"

#macro __VINYL_RUNNING_FROM_IDE  (GM_build_type == "run")

enum __VINYL_SOUND_TYPE {
    __UNKNOWN,
    __WAD,
    __EXTERNAL_WAV,
    __EXTERNAL_OGG,
}

enum __VINYL_HLT_STATE
{
    __HEAD,
    __LOOP,
    __TAIL,
}

enum VINYL_QUEUE
{
    PLAY_THROUGH,
    LOOP_EACH,
    LOOP_ON_LAST,
}

__VinylSystem();
function __VinylSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    _system = {};
    
    with(_system)
    {
        if (VINYL_DEBUG_SHOW_FRAMES) __frame = 0;
        
        __VinylTrace("Welcome to Vinyl! This is version ", __VINYL_VERSION, ", ", __VINYL_DATE);
        if (__VINYL_RUNNING_FROM_IDE) global.Vinyl = self;
        
        //Lookup dictionaries for sound/pattern/mix definitions.
        __soundDict   = {};
        __patternDict = {};
        __mixDict     = {};
        
        //Array of mixes that need updating every frame
        __mixArray = [];
        
        //Struct that converts integer keys (voice references) to voice data structs. This is used
        //to efficiently find Vinyl's addition voice data using voice references
        __voiceLookUpDict = {};
        
        //An array of voices that are in the lookup dictionary. This will never include HLT voices
        //as they are managed in the update array (see below). Blend voices will automatically be
        //put into this array. Sound voices will automatically be put into this array in Live Edit
        //mode or if some additional property needs to be attached to the voice e.g. fading out or
        //setting gain.
        __voiceCleanUpArray = [];
        __cleanUpIndex      = 0;
        
        //An array of voice structs that need to be actively managed. This will always include HLT
        //voices. Sound voices and Blend voices are added to the update array when a fade out
        //operation is called on them.
        __voiceUpdateArray = [];
        
        //Set the master gain to 1. The actual gain value we pass into GameMaker's native function
        //is some multiple of this value so we want to initialize early to ensure the native gain
        //is set properly for unity gain.
        VinylMasterSetGain(1);
        
        //Build sound patterns for every single sound in the project. This saves extra work later.
        var _defaultMix = (VINYL_DEFAULT_MIX == VINYL_NO_MIX)? undefined : VINYL_DEFAULT_MIX;
        var _soundDict = __soundDict;
        var _assetArray = asset_get_ids(asset_sound);
        var _i = 0;
        repeat(array_length(_assetArray))
        {
            var _sound = _assetArray[_i];
            struct_set_from_hash(_soundDict, int64(_sound), new __VinylClassPatternSound(_sound, 1, 1, 1, 1, false, _defaultMix));
            ++_i;
        }
        
        //Import the boot setup JSON
        __VinylConfigBootSetupJSON();
        VinylSetupImportJSON(global.VinylBootSetupJSON, false);
        
        //Set up an update function that executes one every frame forever.
        time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, method(self, function()
        {
            static _voiceLookUpDict = __voiceLookUpDict;
            static _bootSetupTimer  = 0;
            static _bootSetupPath   = VINYL_LIVE_EDIT? filename_dir(GM_project_filename) + "/scripts/__VinylConfigBootSetupJSON/__VinylConfigBootSetupJSON.gml" : undefined;
            static _bootSetupHash   = undefined;
            
            if (VINYL_DEBUG_SHOW_FRAMES) __frame++;
            
            var _deltaTimeFactor = (delta_time / (game_get_speed(gamespeed_fps)*game_get_speed(gamespeed_microseconds)));
            
            //Handle live update from boot setup JSON
            if (VINYL_LIVE_EDIT && ((os_type == os_windows) || (os_type == os_macosx) || (os_type == os_linux)))
            {
                --_bootSetupTimer;
                if (_bootSetupTimer <= 0)
                {
                    _bootSetupTimer = 60;
                    
                    var _newHash = md5_file(_bootSetupPath);
                    if (_newHash != _bootSetupHash)
                    {
                        if (_bootSetupHash == undefined)
                        {
                            _bootSetupHash = _newHash;
                        }
                        else
                        {
                            _bootSetupHash = _newHash;
                            
                            var _buffer = buffer_load(_bootSetupPath);
                            var _gml = SnapBufferReadGML(_buffer, 0, buffer_get_size(_buffer));
                            buffer_delete(_buffer);
                            
                            VinylSetupImportJSON(_gml[$ "global.VinylBootSetupJSON"] ?? []);
                        }
                    }
                }
            }
            
            //Update voices that need it
            var _array = __voiceUpdateArray;
            var _i = 0;
            repeat(array_length(_array))
            {
                if (not _array[_i].__Update(_deltaTimeFactor))
                {
                    array_delete(_array, _i, 1);
                }
                else
                {
                    ++_i;
                }
            }
            
            //Update mixes
            var _array = __mixArray;
            var _i = 0;
            repeat(array_length(_array))
            {
                _array[_i].__Update(_deltaTimeFactor);
                ++_i;
            }
            
            //Check for clean up
            var _array = __voiceCleanUpArray;
            var _length = array_length(_array);
            if (_length > 0)
            {
                var _index = (__cleanUpIndex + 1) mod _length;
                if (not VinylIsPlaying(_array[_index]))
                {
                    var _voice = _array[_index];
                    
                    //FIXME - Replace with struct_remove_from_hash() when that is made available
                    struct_set_from_hash(_voiceLookUpDict, int64(_voice), undefined);
                    if (VINYL_DEBUG_LEVEL >= 2) __VinylTrace("Removing ", _voice, " from voice lookup struct");
                    
                    array_delete(_array, _index, 1);
                }
                
                __cleanUpIndex = _index;
            }
        }), [], -1));
    }
    
    return _system;
}