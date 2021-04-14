/// @param asset

function VinylBasic(_asset)
{
    return __VinylPatternizeSource(_asset);
}

/// @param asset
function __VinylPatternBasic(_asset) constructor
{
    __VinylPatternCommonConstruct(__VinyInstanceBasic);
    
    __asset = _asset;
    
    
    
    #region Common Public Methods
    
    static Play        = __VinylPatternPlay;
    static GainSet     = __VinylPatternGainSet;
    static GainGet     = __VinylPatternGainGet;
    static PitchSet    = __VinylPatternPitchSet;
    static PitchGet    = __VinylPatternPitchGet;
    static FadeTimeSet = __VinylPatternFadeTimeSet;
    static FadeTimeGet = __VinylPatternFadeTimeGet;
    
    #endregion
    
    
    
    #region Public Methods
    
    static AssetGet = function()
    {
        return __asset;
    }
    
    #endregion
    
    
    
    #region Private Methods
    
    static toString = function()
    {
        return __VinylGetSourceName(__asset);
    }
    
    #endregion
    
    
    
    if (VINYL_DEBUG) __VinylTrace("Created pattern for ", self);
}

/// @param asset
function __VinyInstanceBasic(_pattern) constructor
{
    __VinylInstanceCommonConstruct(_pattern);
    
    __asset      = __pattern.__asset;
    __GMInstance = undefined;
    
    
    
    #region Public Methods
    
    static PositionGet = function()
    {
        if (!__started || __finished || !is_numeric(__GMInstance) || !audio_is_playing(__GMInstance)) return undefined;
        return audio_sound_get_track_position(__GMInstance);
    }
    
    /// @param time
    static PositionSet = function(_time)
    {
        if ((_time != undefined) && __started && !__finished && is_numeric(__GMInstance) && audio_is_playing(__GMInstance))
        {
            audio_sound_set_track_position(__GMInstance, _time);
        }
    }
    
    static Stop = function()
    {
        if (!__stopping && !__finished)
        {
            if (VINYL_DEBUG) __VinylTrace("Stopping ", self);
            
            __stopping = true;
            __timeStopping = current_time;
        }
    }
    
    static Kill = function()
    {
        if (__started && !__finished && VINYL_DEBUG) __VinylTrace("Killed ", self);
        
        if (!__finished)
        {
            if (is_numeric(__GMInstance) && audio_is_playing(__GMInstance)) audio_stop_sound(__GMInstance);
            
            __stopping   = false;
            __finished   = true;
            __GMInstance = undefined;
        }
    }
    
    static AssetGet = function()
    {
        return __asset;
    }
    
    static GMInstanceGet = function()
    {
        return __GMInstance;
    }
    
    #endregion
    
    
    
    #region Common Public Methods
    
    static GainSet        = __VinylInstanceGainSet;
    static GainTargetSet  = __VinylInstanceGainTargetSet;
    static GainGet        = __VinylInstanceGainGet;
    static PitchSet       = __VinylInstancePitchSet;
    static PitchTargetSet = __VinylInstancePitchTargetSet;
    static PitchTargetSet = __VinylInstancePitchTargetSet;
    static FadeTimeSet    = __VinylInstanceFadeTimeSet;
    static FadeTimeGet    = __VinylInstanceFadeTimeGet;
    static PatternGet     = __VinylInstancePatternGet;
    static IsStopping     = __VinylInstanceIsStopping;
    static IsFinished     = __VinylInstanceIsFinished;
    
    #endregion
    
    
    
    #region Private Methods
    
    static __Reset = function()
    {
        __VinylInstanceCommonReset();
        
        __GMInstance = undefined;
    }
    
    static __Play = function()
    {
        __VinylInstanceCommonPlay();
        
        //Play the audio asset
        __GMInstance = audio_play_sound(__asset, 1, false);
        audio_sound_gain(__GMInstance, __gain, 0.0);
        audio_sound_pitch(__GMInstance, __pitch);
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
            __VinylInstanceCommonTick();
            
            //Handle fade out
            if (__stopping && (current_time - __timeStopping > __timeFadeOut)) Kill();
            
            if (is_numeric(__GMInstance) && audio_is_playing(__GMInstance))
            {
                var _asset_gain = global.__vinylGlobalAssetGain[? __asset];
                if (_asset_gain == undefined) _asset_gain = 1.0;
                
                //Update GM's sound instance
                audio_sound_gain(__GMInstance, __gain*_asset_gain, VINYL_STEP_DURATION);
                audio_sound_pitch(__GMInstance, __pitch);
            }
            
            if (!__finished)
            {
                //If our sound instance is somehow invalid, stop this instance
                if (!is_numeric(__GMInstance) || !audio_is_playing(__GMInstance)) Kill();
            }
        }
    }
    
    static __WillFinish = function()
    {
        if (!__started || __finished || !is_numeric(__GMInstance) || !audio_is_playing(__GMInstance)) return true;
        return (((audio_sound_length(__GMInstance) - audio_sound_get_track_position(__GMInstance)) / __pitch) <= (VINYL_STEP_DURATION/1000));
    }
    
    static toString = function()
    {
        return __VinylGetSourceName(__asset);
    }
    
    #endregion
    
    
    
    __Reset();
    
    if (VINYL_DEBUG) __VinylTrace("Created instance for ", self);
}