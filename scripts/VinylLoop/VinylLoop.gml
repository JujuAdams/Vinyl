/// @param intro
/// @param loop
/// @param outro

function VinylLoop()
{
    if (argument_count == 1)
    {
        return new __VinylPatternLoop(undefined, argument[0], undefined);
    }
    else if (argument_count == 3)
    {
        var _intro = (argument[0] == "")? undefined : argument[0];
        var _outro = (argument[2] == "")? undefined : argument[2];
        return new __VinylPatternLoop(_intro, argument[1], _outro);
    }
    else
    {
        __VinylError("Unsupported number of arguments (", argument_count, ") for VinylLoop()\n(Should be 1, 2, or 3. Use <undefined> or \"\" as an argument for no source");
    }
}

/// @param intro
/// @param loop
/// @param outro
function __VinylPatternLoop(_intro, _loop, _outro) constructor
{
    __VinylPatternCommonConstruct();
    
    __waitToPlayOutro = true;
    
    __intro = _intro;
    __loop  = _loop;
    __outro = _outro;
    
    
    
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
    
    static WaitToPlayOutroSet = function(_state)
    {
        __waitToPlayOutro = _state;
        return self;
    }
    
    static WaitToPlayOutroGet = function()
    {
        return __waitToPlayOutro;
    }
    
    static IntroGet = function()
    {
        return __intro;
    }
    
    static LoopGet = function()
    {
        return __loop;
    }
    
    static OutroGet = function()
    {
        return __outro;
    }
    
    #endregion
    
    
    
    #region Private Methods
    
    static __Play = function(_direct)
    {
        var _intro = __VinylPatternizeSource(__intro);
        var _loop  = __VinylPatternizeSource(__loop );
        var _outro = __VinylPatternizeSource(__outro);
        
        //Generate child instances
        _intro = (_intro != undefined)? _intro.__Play(false) : undefined;
        _loop  =                         _loop.__Play(false);
        _outro = (_outro != undefined)? _outro.__Play(false) : undefined;
        
        //Generate our own instance
        with(new __VinyInstanceLoop(_intro, _loop, _outro, __waitToPlayOutro))
        {
            __pattern = other;
            __Reset();
            if (_direct) __bussName = other.__bussName;
            return self;
        }
    }
    
    static toString = function()
    {
        return "Loop [ " + __VinylGetSourceName(__intro) + "," + __VinylGetSourceName(__loop) + "," + __VinylGetSourceName(__outro) + " ]";
    }
    
    #endregion
    
    
    
    if (__VINYL_DEBUG) __VinylTrace("Created pattern ", self);
}

/// @param intro
/// @param loop
/// @param outro
/// @param waitToPlayOutro
function __VinyInstanceLoop(_intro, _loop, _outro, _wait_to_play_outro) constructor
{
    __VinylInstanceCommonConstruct();
    
    __intro = _intro;
    __loop  = _loop;
    __outro = _outro;
    
    __waitToPlayOutro = _wait_to_play_outro;
    
    if (__intro != undefined) __intro.__parent = self;
    __loop.__parent = self;
    if (__outro != undefined) __outro.__parent = self;
    
    
    
    #region Public Methods
    
    static PositionGet = function()
    {
        if (!__started || __finished || !is_struct(__current)) return undefined;
        return __current.PositionGet();
    }
    
    /// @param time
    static PositionSet = function(_time)
    {
        //TODO - Make this more accuracte by taking into account the length of the intro (if one exists)
        if ((_time != undefined) && __started && !__finished && is_struct(__current))
        {
            __current.PositionSet(_time);
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
    
    static Kill = function()
    {
        if (!__finished && __VINYL_DEBUG) __VinylTrace("Killed ", self);
        
        if (__intro != undefined) __intro.Kill();
        __loop.Kill();
        if (__outro != undefined) __outro.Kill();
        
        __stopping = false;
        __finished = true;
        __current  = undefined;
    }
    
    static PhaseGet = function()
    {
        if (__current == undefined) return undefined;
        
        if (__current == __intro) return 0;
        if (__current == __loop ) return 1;
        if (__current == __outro) return 2;
        
        return undefined;
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
    static BussSet        = __VinylInstanceBussSet;
    static BussGet        = __VinylInstanceBussGet;
    static PatternGet     = __VinylInstancePatternGet;
    static IsStopping     = __VinylInstanceIsStopping;
    static IsFinished     = __VinylInstanceIsFinished;
    
    #endregion
    
    
    
    #region Private Methods
    
    static __Reset = function()
    {
        __VinylInstanceCommonReset();
        
        __current = undefined;
    
        if (__intro != undefined) __intro.__Reset();
        __loop.__Reset();
        if (__outro != undefined) __outro.__Reset();
    }
    
    static __Play = function()
    {
        __VinylInstanceCommonPlay(false);
        
        if (__VINYL_DEBUG) __VinylTrace("Playing ", self, " (buss=\"", __bussName, "\", gain=", __gain, ", pitch=", __pitch, ")");
        
        //Figure out what to play
        __current = (__intro != undefined)? __intro : __loop;
        with(__current) __Play();
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
            __VinylInstanceCommonTick(false);
            
            //Handle fade out
            if (__timeFadeOut > 0.0)
            {
                if (__stopping && (current_time - __timeStopping > __timeFadeOut)) Kill();
            }
            
            if (__current != undefined)
            {
                with(__current) __Tick();
                
                if (__current.__WillFinish())
                {
                    if (__current == __intro)
                    {
                        __current = __loop;
                        __current.__Play();
                    }
                    else if (__current == __loop)
                    {
                        if (!__stopping)
                        {
                            __loop.__Play();
                        }
                        else if (__outro != undefined)
                        {
                            __current = __outro;
                            __current.__Play();
                        }
                        else
                        {
                            Kill();
                        }
                    }
                    else
                    {
                        Kill();
                    }
                }
                else if (__started && __stopping && !__waitToPlayOutro && (__outro != undefined) && (__current != __outro))
                {
                    __current.Kill();
                    __current = __outro;
                    __current.__Play();
                }
            }
        }
    }
    
    static __WillFinish = function()
    {
        if (__intro != undefined)
        {
            if (!__intro.__WillFinish()) return false;
        }
        
        if (!__loop.__WillFinish()) return false;
        
        if (__outro != undefined)
        {
            if (!__outro.__WillFinish()) return false;
        }
        
        return true;
    }
    
    static toString = function()
    {
        return "Loop [ " + __VinylGetSourceName(__intro) + "," + __VinylGetSourceName(__loop) + "," + __VinylGetSourceName(__outro) + " ]";
    }
    
    #endregion
    
    
    
    __Reset();
    
    if (__VINYL_DEBUG) __VinylTrace("Created instance ", self);
}