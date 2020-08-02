/// @param intro
/// @param loop
/// @param outro

function vinyl_loop()
{
    if (argument_count == 1)
    {
        return new __vinyl_pattern_loop(undefined, argument[0], undefined);
    }
    else if (argument_count == 3)
    {
        var _intro = (argument[0] == "")? undefined : argument[0];
        var _outro = (argument[0] == "")? undefined : argument[0];
        return new __vinyl_pattern_loop(_intro, argument[1], _outro);
    }
    else
    {
        __vinyl_error("Unsupported number of arguments (", argument_count, ") for vinyl_loop()\n(Should be 1 or 3, use <undefined> or \"\" for no source");
    }
}

/// @param intro
/// @param loop
/// @param outro
function __vinyl_pattern_loop(_intro, _loop, _outro) constructor
{
    __vinyl_pattern_common();
    
    __intro = __vinyl_patternize_source(_intro);
    __loop  = __vinyl_patternize_source(_loop );
    __outro = __vinyl_patternize_source(_outro);
    
    generate = function()
    {
        var _intro = (__intro != undefined)? __intro.generate() : undefined;
        var _outro = (__outro != undefined)? __outro.generate() : undefined;
        return new __vinyl_player_loop(_intro, __loop.generate(), _outro);
    }
    
    toString = function()
    {
        return "Loop [ " + __vinyl_get_source_name(__intro) + "," + __vinyl_get_source_name(__loop) + "," + __vinyl_get_source_name(__outro) + " ]";
    }
    
    if (__VINYL_DEBUG) __vinyl_trace("Created pattern ", self);
}

/// @param intro
/// @param loop
/// @param outro
function __vinyl_player_loop(_intro, _loop, _outro) constructor
{
    __vinyl_player_common();
    
    __intro = _intro;
    __loop  = _loop;
    __outro = _outro;
    
    __current = undefined;
    
    play = function()
    {
        if (__gain  == undefined) __gain  = gain;
        if (__pitch == undefined) __pitch = pitch;
        
        if (__VINYL_DEBUG) __vinyl_trace("Starting player (gain=", __gain, ", pitch=", __pitch, ") ", self);
        
        __current = (__intro != undefined)? __intro : __loop;
        with(__current) play();
        
        __started = true;
        __finished = false;
    }
    
    stop = function()
    {
        if (__VINYL_DEBUG) __vinyl_trace(self, " stopping");
        
        __stopping = true;
    }
    
    stop_now = function()
    {
        if (__VINYL_DEBUG) __vinyl_trace(self, " finished");
        
        if (__intro != undefined) with(__intro) stop_now();
        with(__loop) stop_now();
        if (__outro != undefined) with(__outro) stop_now();
        
        __stopping = false;
        __finished = true;
        __current  = undefined;
    }
    
    tick = function()
    {
        if (!__started && !__stopping)
        {
            play();
        }
        else
        {
            if (__gain  != gain ) __gain  = gain;
            if (__pitch != pitch) __pitch = pitch;
            
            if (__current != undefined)
            {
                with(__current) tick();
                
                if (__current.__finished)
                {
                    if (__current == __intro)
                    {
                        __current = __loop;
                        __current.play();
                    }
                    else if (__current == __loop)
                    {
                        if (!__stopping)
                        {
                            __loop.play();
                        }
                        else if (__outro != undefined)
                        {
                            __current = __outro;
                            __current.play();
                        }
                        else
                        {
                            stop_now();
                        }
                    }
                    else
                    {
                        stop_now();
                    }
                }
            }
        }
    }
    
    toString = function()
    {
        return "Loop [ " + __vinyl_get_source_name(__intro) + "," + __vinyl_get_source_name(__loop) + "," + __vinyl_get_source_name(__outro) + " ]";
    }
    
    if (__VINYL_DEBUG) __vinyl_trace("Created player ", self);
}