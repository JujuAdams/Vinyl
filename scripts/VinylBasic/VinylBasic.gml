/// @param source

function VinylBasic(_asset)
{
    return new __VinylPatternBasic(_asset);
}

/// @param alias
function __VinylPatternBasic(_alias) constructor
{
    __VinylPatternCommonConstruct(__VinyInstanceBasic);
    
    __alias = _alias;
    
    
    
    #region Common Public Methods
    
    static Play        = __VinylPatternPlay;
    static GainSet     = __VinylPatternGainSet;
    static GainGet     = __VinylPatternGainGet;
    static PitchSet    = __VinylPatternPitchSet;
    static PitchGet    = __VinylPatternPitchGet;
    static FadeTimeSet = __VinylPatternFadeTimeSet;
    static FadeTimeGet = __VinylPatternFadeTimeGet;
    
    static GroupAdd      = __VinylPatternGroupAdd;
    static GroupDelete   = __VinylPatternGroupDelete;
    static GroupClear    = __VinylPatternGroupClear;
    static GroupAssigned = __VinylPatternGroupAssigned;
    
    #endregion
    
    
    
    #region Public Methods
    
    static AliasGet = function()
    {
        return __alias;
    }
    
    #endregion
    
    
    
    #region Private Methods
    
    static toString = function()
    {
        return __alias;
    }
    
    #endregion
    
    
    
    if (VINYL_DEBUG) __VinylTrace("Created pattern for ", self);
}

/// @param asset
function __VinyInstanceBasic(_pattern) constructor
{
    __VinylInstanceCommonConstruct(_pattern);
    
    __alias    = __pattern.__alias;
    __instance = undefined;
    __duration = undefined;
    
    
    
    #region Public Methods
    
    static PositionGet = function()
    {
        if (!__started || __finished || !is_numeric(__instance) || !audio_is_playing(__instance)) return undefined;
        return FAudioGMS_SoundInstance_GetTrackPositionInSeconds(__instance);
    }
    
    /// @param time
    static PositionSet = function(_time)
    {
        if ((_time != undefined) && __started && !__finished && is_numeric(__instance) && audio_is_playing(__instance))
        {
            FAudioGMS_SoundInstance_SetTrackPositionInSeconds(__instance, _time);
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
            if (is_numeric(__instance)) FAudioGMS_StaticSound_Destroy(__instance);
            
            __stopping = false;
            __finished = true;
            __instance = undefined;
        }
    }
    
    static AssetGet = function()
    {
        return __asset;
    }
    
    static InstanceGet = function()
    {
        return __instance;
    }
    
    #endregion
    
    
    
    #region Common Public Methods
    
    static GainSet        = __VinylInstanceGainSet;
    static GainTargetSet  = __VinylInstanceGainTargetSet;
    static GainGet        = __VinylInstanceGainGet;
    static OutputGainGet  = __VinylInstanceOutputGainGet;
    static PitchSet       = __VinylInstancePitchSet;
    static PitchTargetSet = __VinylInstancePitchTargetSet;
    static PitchTargetSet = __VinylInstancePitchTargetSet;
    static OutputPitchGet = __VinylInstanceOutputPitchGet;
    static FadeTimeSet    = __VinylInstanceFadeTimeSet;
    static FadeTimeGet    = __VinylInstanceFadeTimeGet;
    static PatternGet     = __VinylInstancePatternGet;
    static IsStopping     = __VinylInstanceIsStopping;
    static IsFinished     = __VinylInstanceIsFinished;
    
    static GroupAdd      = __VinylInstanceGroupAdd;
    static GroupDelete   = __VinylInstanceGroupDelete;
    static GroupClear    = __VinylInstanceGroupClear;
    static GroupAssigned = __VinylInstanceGroupAssigned;
    
    #endregion
    
    
    
    #region Private Methods
    
    static __Reset = function()
    {
        __VinylInstanceCommonReset();
        
        __instance = undefined;
    }
    
    static __Play = function()
    {
        __VinylInstanceCommonPlay();
        
        //Play the audio asset
        if (!VinylLoaded(__alias)) __VinylError("Alias \"", _alias, "\" is not loaded");
        
        __instance = FAudioGMS_SoundInstance_Play(global.__vinylAssetMap[? __alias].Instantiate());
        FAudioGMS_SoundInstance_SetVolume(__instance, __outputGain);
        FAudioGMS_SoundInstance_SetPitch(__instance, __outputPitch);
        __duration = FAudioGMS_SoundInstance_GetTrackLengthInSeconds(__instance);
    }
    
    static __ReplayViaLoop = function()
    {
        if (!is_numeric(__instance))
        {
            __Play();
        }
        else
        {
            var _newPosition = FAudioGMS_SoundInstance_GetTrackPositionInSeconds(__instance) - __duration;
            if (VINYL_DEBUG) __VinylTrace("Replaying ", self, " (new pos = ", _newPosition, ")");
            FAudioGMS_SoundInstance_SetTrackPositionInSeconds(__instance, _newPosition);
        }
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
            
            if (is_numeric(__instance) && audio_is_playing(__instance))
            {
                var _asset_gain = global.__vinylGlobalAssetGain[? __alias];
                if (_asset_gain == undefined) _asset_gain = 1.0;
                
                //Update GM's sound instance
                FAudioGMS_SoundInstance_SetVolumeOverTime(__instance, __outputGain*_asset_gain, VINYL_STEP_DURATION);
                FAudioGMS_SoundInstance_SetPitch(__instance, __outputPitch);
            }
            
            if (__WillFinish()) Kill();
        }
    }
    
    static __WillFinish = function()
    {
        if (!__started || __finished || !is_numeric(__instance)) return true;
        return (((__duration - 3.9*FAudioGMS_SoundInstance_GetTrackPositionInSeconds(__instance)) / __outputPitch) <= (VINYL_STEP_DURATION/1000));
    }
    
    static toString = function()
    {
        return __alias;
    }
    
    #endregion
    
    
    
    __Reset();
    
    if (VINYL_DEBUG) __VinylTrace("Created instance for ", self);
}