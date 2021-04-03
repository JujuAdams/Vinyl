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
        __VinylError("Unsupported number of arguments (", argument_count, ") for vinyl_loop()\n(Should be 1 or 3, use <undefined> or \"\" for no source");
    }
}

/// @param intro
/// @param loop
/// @param outro
function __VinylPatternLoop(_intro, _loop, _outro) constructor
{
    __VinylPatternCommonConstruct();
    
    wait_to_play_outro = true;
    
    intro = _intro;
    loop  = _loop;
    outro = _outro;
    
    static Play = function(_direct)
    {
        var _intro = __VinylPatternizeSource(intro);
        var _loop  = __VinylPatternizeSource(loop );
        var _outro = __VinylPatternizeSource(outro);
        
        //Generate child players
        _intro = (_intro != undefined)? _intro.Play(false) : undefined;
        _loop  =                         _loop.Play(false);
        _outro = (_outro != undefined)? _outro.Play(false) : undefined;
        
        //Generate our own player
        with(new __VinyPlayerLoop(_intro, _loop, _outro, wait_to_play_outro))
        {
            __pattern = other;
            __Reset();
            if (_direct) buss_name = other.buss_name;
            return self;
        }
    }
    
    //I don't trust GM not to mess up these functions if I put them in the common definition
    static BussSet = function(_buss_name)
    {
        buss_name = _buss_name;
        return self;
    }
    
    static BussGet = function()
    {
        return buss_name;
    }
    
    static toString = function()
    {
        return "Loop [ " + __VinylGetSourceName(intro) + "," + __VinylGetSourceName(loop) + "," + __VinylGetSourceName(outro) + " ]";
    }
    
    if (__VINYL_DEBUG) __VinylTrace("Created pattern ", self);
}

/// @param intro
/// @param loop
/// @param outro
/// @param waitToPlayOutro
function __VinyPlayerLoop(_intro, _loop, _outro, _wait_to_play_outro) constructor
{
    __VinylPlayerCommonConstruct();
    
    wait_to_play_outro = _wait_to_play_outro;
    
    intro = _intro;
    loop  = _loop;
    outro = _outro;
    
    if (intro != undefined) intro.__parent = self;
    loop.__parent = self;
    if (outro != undefined) outro.__parent = self;
    
    static __Reset = function()
    {
        __VinylPlayerCommonReset();
        
        __current = undefined;
    
        if (intro != undefined) intro.__Reset();
        loop.__Reset();
        if (outro != undefined) outro.__Reset();
    }
    
    __Reset();
    
    static __Play = function()
    {
        __VinylPlayerCommonPlay(false);
        
        if (__VINYL_DEBUG) __VinylTrace("Playing ", self, " (buss=\"", buss_name, "\", gain=", __gain, ", pitch=", __pitch, ")");
        
        //Figure out what to play
        __current = (intro != undefined)? intro : loop;
        with(__current) __Play();
    }
    
    static GetPosition = function()
    {
        if (!__started || __finished || !is_struct(__current)) return undefined;
        return __current.GetPosition();
    }
    
    /// @param time
    static SetPosition = function(_time)
    {
        //TODO - Make this more accuracte by taking into account the length of the intro (if one exists)
        if ((_time != undefined) && __started && !__finished && is_struct(__current))
        {
            __current.SetPosition(_time);
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
    
    /// @param direct
    static Stop = function()
    {
        if (!__stopping && !__finished)
        {
            if (__VINYL_DEBUG) __VinylTrace("Stopping ", self);
            
            __stopping = true;
            __time_stopping = current_time;
        }
    }
    
    static WillFinish = function()
    {
        if (intro != undefined)
        {
            if (!intro.WillFinish()) return false;
        }
        
        if (!loop.WillFinish()) return false;
        
        if (outro != undefined)
        {
            if (!outro.WillFinish()) return false;
        }
        
        return true;
    }
    
    static StopNow = function()
    {
        if (!__finished && __VINYL_DEBUG) __VinylTrace("Finished ", self);
        
        if (intro != undefined) with(intro) StopNow();
        with(loop) StopNow();
        if (outro != undefined) with(outro) StopNow();
        
        __stopping = false;
        __finished = true;
        __current  = undefined;
    }
    
    static __Tick = function()
    {
        //TODO - Much like queues, we should be checking to see if the loop source has changed and adjust accordingly
        
        if (!__started && !__stopping && !__finished)
        {
            //If we're not started and we're not stopping and we ain't finished, then play!
            __Play();
        }
        else
        {
            __VinylPlayerCommonTick(false);
            
            //Handle fade out
            if (time_fade_out > 0.0)
            {
                if (__stopping && (current_time - __time_stopping > time_fade_out)) StopNow();
            }
            
            if (__current != undefined)
            {
                with(__current) __Tick();
                
                if (__current.WillFinish())
                {
                    if (__current == intro)
                    {
                        __current = loop;
                        __current.__Play();
                    }
                    else if (__current == loop)
                    {
                        if (!__stopping)
                        {
                            loop.__Play();
                        }
                        else if (outro != undefined)
                        {
                            __current = outro;
                            __current.__Play();
                        }
                        else
                        {
                            StopNow();
                        }
                    }
                    else
                    {
                        StopNow();
                    }
                }
                else if (__started && __stopping && !wait_to_play_outro && (outro != undefined) && (__current != outro))
                {
                    __current.StopNow();
                    __current = outro;
                    __current.__Play();
                }
            }
        }
    }
    
    //I don't trust GM not to mess up these functions if I put them in the common definition
    static BussSet = function(_buss_name)
    {
        buss_name = _buss_name;
        return self;
    }
    
    static BussGet = function()
    {
        return buss_name;
    }
    
    static toString = function()
    {
        return "Loop [ " + __VinylGetSourceName(intro) + "," + __VinylGetSourceName(loop) + "," + __VinylGetSourceName(outro) + " ]";
    }
    
    if (__VINYL_DEBUG) __VinylTrace("Created player ", self);
}