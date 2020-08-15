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
        var _outro = (argument[2] == "")? undefined : argument[2];
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
    __vinyl_pattern_common_construct();
    
    __intro = __vinyl_patternize_source(_intro);
    __loop  = __vinyl_patternize_source(_loop );
    __outro = __vinyl_patternize_source(_outro);
    
    generate = function(_direct)
    {
        //Generate child players
        var _intro = (__intro != undefined)? __intro.generate(false) : undefined;
        var _loop  =                          __loop.generate(false);
        var _outro = (__outro != undefined)? __outro.generate(false) : undefined;
        
        //Generate our own player
        with(new __vinyl_player_loop(_intro, _loop, _outro))
        {
            __pattern = other;
            reset();
            if (_direct) buss_name = other.buss_name;
            return self;
        }
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
    __vinyl_player_common_construct();
    
    __intro = _intro;
    __loop  = _loop;
    __outro = _outro;
    
    var _i = 0;
    repeat(array_length(__sources))
    {
        __sources[_i].__parent = self;
        ++_i;
    }
    
    if (__intro != undefined) __intro.__parent = self;
    __loop.__parent = self;
    if (__outro != undefined) __outro.__parent = self;
    
    reset = function()
    {
        __vinyl_player_common_reset();
        
        __current = undefined;
    
        if (__intro != undefined) __intro.reset();
        __loop.reset();
        if (__outro != undefined) __outro.reset();
    }
    
    play = function()
    {
        __vinyl_player_common_play(false);
        
        if (__VINYL_DEBUG) __vinyl_trace("Playing (buss=\"", buss_name, "\", gain=", __gain, ", pitch=", __pitch, ") ", self);
        
        //Figure out what to play
        __current = (__intro != undefined)? __intro : __loop;
        with(__current) play();
    }
    
    stop = function(_direct)
    {
        if (__VINYL_DEBUG) __vinyl_trace(self, " stopping");
        
        __stopping = true;
        __time_stopping = current_time;
    }
    
    finish = function()
    {
        if (!__finished && __VINYL_DEBUG) __vinyl_trace(self, " finished");
        
        if (__intro != undefined) with(__intro) finish();
        with(__loop) finish();
        if (__outro != undefined) with(__outro) finish();
        
        __stopping = false;
        __finished = true;
        __current  = undefined;
    }
    
    tick = function(_parent)
    {
        if (!__started && !__stopping && !__finished)
        {
            //If we're not started and we're not stopping and we ain't finished, then play!
            play();
        }
        else
        {
            __vinyl_player_common_tick(false);
            
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
                            finish();
                        }
                    }
                    else
                    {
                        finish();
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