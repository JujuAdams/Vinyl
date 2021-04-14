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
    __VinylPatternCommonConstruct(__VinyInstanceLoop);
    
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
    
    #endregion
    
    
    
    #region Public Methods
    
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
    
    static toString = function()
    {
        return "Loop [ " + __VinylGetSourceName(__intro) + "," + __VinylGetSourceName(__loop) + "," + __VinylGetSourceName(__outro) + " ]";
    }
    
    #endregion
    
    
    
    if (VINYL_DEBUG) __VinylTrace("Created pattern ", self);
}

/// @param intro
/// @param loop
/// @param outro
/// @param waitToPlayOutro
function __VinyInstanceLoop(_pattern) constructor
{
    __VinylInstanceCommonConstruct(_pattern);
    
    //Generate child instances
    __intro = __VinylPatternizeSource(__pattern.__intro);
    __loop  = __VinylPatternizeSource(__pattern.__loop );
    __outro = __VinylPatternizeSource(__pattern.__outro);
    
    __intro = (__intro != undefined)? __intro.__Play() : undefined;
    __loop  =                          __loop.__Play();
    __outro = (__outro != undefined)? __outro.__Play() : undefined;
    
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
            if (VINYL_DEBUG) __VinylTrace("Stopping ", self);
            
            __stopping = true;
            __timeStopping = current_time;
        }
    }
    
    static Kill = function()
    {
        if (__started && !__finished && VINYL_DEBUG) __VinylTrace("Killed ", self);
        
        if (__intro != undefined) __intro.Kill();
        __loop.Kill();
        if (__outro != undefined) __outro.Kill();
        
        __stopping = false;
        __finished = true;
        __current  = undefined;
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
        __VinylInstanceCommonPlay();
        
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
            __VinylInstanceCommonTick();
            
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
    
    if (VINYL_DEBUG) __VinylTrace("Created instance ", self);
}