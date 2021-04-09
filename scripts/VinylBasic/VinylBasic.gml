/// @param asset

function VinylBasic(_asset)
{
    return __VinylPatternizeSource(_asset);
}

/// @param asset
function __VinylPatternBasic(_asset) constructor
{
    __VinylPatternCommonConstruct();
    
    __asset = _asset;
    
    
    
    #region Public Methods
    
    static Play = function()
    {
        var _instance = __Play(true);
        ds_list_add(global.__vinylPlaying, _instance);
        return _instance;
    }
    
    //Gain access
    static SetGain = function()
    {
        var _min = ((argument_count > 0) && (argument[0] != undefined))? argument[0] : 1.0;
        var _max = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : _min;
        
        __gainMin = _min;
        __gainMax = _max;
        
        return self;
    }
    
    static GetGain = function()
    {
        return { mini : __gainMin, maxi : __gainMax };
    }
    
    //Pitch access
    static SetPitch = function()
    {
        var _min = ((argument_count > 0) && (argument[0] != undefined))? argument[0] : 1.0;
        var _max = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : _min;
        
        __pitchMin = _min;
        __pitchMax = _max;
        
        return self;
    }
    
    static GetPitch = function()
    {
        return { mini : __pitchMin, maxi : __pitchMax };
    }
    
    //Fade time access
    static SetFadeTime = function(_inTime, _outTime)
    {
        __timeFadeIn  = _inTime;
        __timeFadeOut = _outTime;
        
        return self;
    }
    
    static GetFadeTime = function()
    {
        return { in : __timeFadeIn, out : __timeFadeOut };
    }
    
    //Buss access
    static BussSet = function(_bussName)
    {
        __bussName = _bussName;
        
        return self;
    }
    
    static BussGet = function()
    {
        return __bussName;
    }
    
    #endregion
    
    
    
    #region Private Methods
    
    static __Play = function(_direct)
    {
        //Generate a player
        with(new __VinyPlayerBasic(__asset))
        {
            __pattern = other;
            __Reset();
            if (_direct) __bussName = other.__bussName;
            return self;
        }
    }
    
    static toString = function()
    {
        return __VinylGetSourceName(__asset);
    }
    
    #endregion
    
    
    
    if (__VINYL_DEBUG) __VinylTrace("Created pattern for ", self);
}

/// @param asset
function __VinyPlayerBasic(_asset) constructor
{
    __VinylPlayerCommonConstruct();
    
    __asset = _asset;
    
    
    
    #region Public Methods
    
    
    
    #region Position/stopping
    
    static GetPosition = function()
    {
        if (!__started || __finished || !is_numeric(__instance) || !audio_is_playing(__instance)) return undefined;
        return audio_sound_get_track_position(__instance);
    }
    
    /// @param time
    static SetPosition = function(_time)
    {
        if ((_time != undefined) && __started && !__finished && is_numeric(__instance) && audio_is_playing(__instance))
        {
            audio_sound_set_track_position(__instance, _time);
        }
    }
    
    static IsStopping = function()
    {
        return __stopping;
    }
    
    static IsFinished = function()
    {
        return __finished;
    }
    
    static Stop = function()
    {
        if (!__stopping && !__finished)
        {
            if (__VINYL_DEBUG) __VinylTrace("Stopping ", self);
            
            __stopping = true;
            __timeStopping = current_time;
        }
    }
    
    static StopNow = function()
    {
        if (__started && !__finished && __VINYL_DEBUG) __VinylTrace("Finished ", self);
        
        if (!__finished)
        {
            if (is_numeric(__instance) && audio_is_playing(__instance)) audio_stop_sound(__instance);
            
            __stopping = false;
            __finished = true;
            __instance = undefined;
        }
    }
    
    static WillFinish = function()
    {
        if (!__started || __finished || !is_numeric(__instance) || !audio_is_playing(__instance)) return true;
        return (((audio_sound_length(__instance) - audio_sound_get_track_position(__instance)) / __pitch) <= (VINYL_STEP_DURATION/1000));
    }
    
    #endregion
    
    
    
    #region Gain/pitch/fade time/buss
    
    //Gain access
    static SetGain = function(_value)
    {
        __gain = _value;
        
        return self;
    }
    
    static SetGainTarget = function(_target, _rate)
    {
        __gainTarget = _target;
        __gainRate = _rate;
        
        return self;
    }
    
    static GetGain = function()
    {
        return __gain;
    }
    
    //Pitch access
    static SetPitch = function(_value)
    {
        __pitch = _value;
        
        return self;
    }
    
    static SetPitchTarget = function(_target, _rate)
    {
        __pitchTarget = _target;
        __pitchRate = _rate;
        
        return self;
    }
    
    static GetPitch = function()
    {
        return __pitch;
    }
    
    //Fade time access
    static SetFadeTime = function(_inTime, _outTime)
    {
        __timeFadeIn  = _inTime;
        __timeFadeOut = _outTime;
        
        return self;
    }
    
    static GetFadeTime = function()
    {
        return { in : __timeFadeIn, out : __timeFadeOut };
    }
    
    //I don't trust GM not to mess up these functions if I put them in the common definition
    static BussSet = function(_buss_name)
    {
        __bussName = _buss_name;
        
        return self;
    }
    
    static BussGet = function()
    {
        return __bussName;
    }
    
    #endregion
    
    
    
    #endregion
    
    
    
    #region Private Methods
    
    static __Reset = function()
    {
        __VinylPlayerCommonReset();
        
        __instance = undefined;
    }
    
    static __Play = function()
    {
        __VinylPlayerCommonPlay(true);
        
        if (__VINYL_DEBUG) __VinylTrace("Playing ", self, " (buss=\"", buss_name, "\", gain=", __gain, ", pitch=", __pitch, ")");
        
        //Play the audio asset
        __instance = audio_play_sound(__asset, 1, false);
        audio_sound_gain(__instance, __gain, 0.0);
        audio_sound_pitch(__instance, __pitch);
    }
    
    static __Tick = function()
    {
        if (!__started && !__stopping && !__finished)
        {
            //If we're not started and we're not stopping and we ain't finished, then play!
            __Play();
        }
        else
        {
            __VinylPlayerCommonTick(true);
            
            //Handle fade out
            if (__stopping && (current_time - __timeStopping > __timeFadeOut)) StopNow();
            
            if (is_numeric(__instance) && audio_is_playing(__instance))
            {
                var _asset_gain = global.__vinylGlobalAssetGain[? __asset];
                if (_asset_gain == undefined) _asset_gain = 1.0;
                
                //Update GM's sound instance
                audio_sound_gain(__instance, __gain*_asset_gain, VINYL_STEP_DURATION);
                audio_sound_pitch(__instance, __pitch);
            }
            
            if (!__finished)
            {
                //If our sound instance is somehow invalid, stop this player
                if (!is_numeric(__instance) || !audio_is_playing(__instance)) StopNow();
            }
        }
    }
    
    static toString = function()
    {
        return __VinylGetSourceName(__asset);
    }
    
    #endregion
    
    
    
    __Reset();
    
    if (__VINYL_DEBUG) __VinylTrace("Created player for ", self);
}