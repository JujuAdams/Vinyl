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
    
    
    
    #region Common Public Methods
    
    static Play        = __VinylPatternPlay;
    static GainSet     = __VinylPatternGainSet;
    static GainGet     = __VinylPatternGainGet;
    static PitchSet    = __VinylPatternPitchSet;
    static PitchGet    = __VinylPatternPitchGet;
    static FadeTimeSet = __VinylPatternFadeTimeSet;
    static FadeTimeGet = __VinylPatternFadeTimeGet;
    static BussSet     = __VinylPatternBussSet;
    static BussGet     = __VinylPatternBussGet;
    
    #endregion
    
    
    
    #region Public Methods
    
    static AssetGet = function()
    {
        return __asset;
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
    
    
    
    #region Common Public Methods (Gain/pitch/fade time/buss)
    
    static GainSet        = __VinylInstanceGainSet;
    static GainTargetSet  = __VinylInstanceGainTargetSet;
    static GainGet        = __VinylInstanceGainGet;
    static PitchSet       = __VinylInstancePitchSet;
    static PitchTargetSet = __VinylInstancePitchTargetSet;
    static PitchTargetSet = __VinylInstancePitchTargetSet;
    static FadeTimeSet    = __VinylInstanceFadeTimeSet;
    static FadeTimeGet    = __VinylInstanceFadeTimeGet;
    static BussSet        = __VinylInstanceBussSet;
    static BussGet        = __VinylInstanceBussGet;
    static IsStopping     = __VinylInstanceIsStopping;
    static IsFinished     = __VinylInstanceIsFinished;
    
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
        
        if (__VINYL_DEBUG) __VinylTrace("Playing ", self, " (buss=\"", __bussName, "\", gain=", __gain, ", pitch=", __pitch, ")");
        
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