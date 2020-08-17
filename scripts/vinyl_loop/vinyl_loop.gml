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
    
    wait_to_play_outro = true;
    
    intro = _intro;
    loop  = _loop;
    outro = _outro;
    
    generate = function(_direct)
    {
        var _intro = __vinyl_patternize_source(intro);
        var _loop  = __vinyl_patternize_source(loop );
        var _outro = __vinyl_patternize_source(outro);
        
        //Generate child players
        _intro = (_intro != undefined)? _intro.generate(false) : undefined;
        _loop  =                         _loop.generate(false);
        _outro = (_outro != undefined)? _outro.generate(false) : undefined;
        
        //Generate our own player
        with(new __vinyl_player_loop(_intro, _loop, _outro, wait_to_play_outro))
        {
            __pattern = other;
            reset();
            if (_direct) buss_name = other.buss_name;
            return self;
        }
    }
    
    toString = function()
    {
        return "Loop [ " + __vinyl_get_source_name(intro) + "," + __vinyl_get_source_name(loop) + "," + __vinyl_get_source_name(outro) + " ]";
    }
    
    if (__VINYL_DEBUG) __vinyl_trace("Created pattern ", self);
}

/// @param intro
/// @param loop
/// @param outro
/// @param waitToPlayOutro
function __vinyl_player_loop(_intro, _loop, _outro, _wait_to_play_outro) constructor
{
    __vinyl_player_common_construct();
    
    wait_to_play_outro = _wait_to_play_outro;
    
    intro = _intro;
    loop  = _loop;
    outro = _outro;
    
    if (intro != undefined) intro.__parent = self;
    loop.__parent = self;
    if (outro != undefined) outro.__parent = self;
    
    reset = function()
    {
        __vinyl_player_common_reset();
        
        __current = undefined;
    
        if (intro != undefined) intro.reset();
        loop.reset();
        if (outro != undefined) outro.reset();
    }
    
    play = function()
    {
        __vinyl_player_common_play(false);
        
        if (__VINYL_DEBUG) __vinyl_trace("Playing ", self, " (buss=\"", buss_name, "\", gain=", __gain, ", pitch=", __pitch, ")");
        
        //Figure out what to play
        __current = (intro != undefined)? intro : loop;
        with(__current) play();
    }
    
    get_position = function()
    {
        if (!__started || __finished || !is_struct(__current)) return undefined;
        return __current.get_position();
    }
    
    /// @param time
    set_position = function(_time)
    {
        //TODO - Make this more accuracte by taking into account the length of the intro (if one exists)
        if ((_time != undefined) && __started && !__finished && is_struct(__current))
        {
            __current.set_position(_time);
        }
    }
    
    /// @param direct
    stop = function(_direct)
    {
        if (!__stopping && !__finished)
        {
            if (__VINYL_DEBUG) __vinyl_trace("Stopping ", self);
            
            __stopping = true;
            __time_stopping = current_time;
        }
    }
    
    will_finish = function()
    {
        if (intro != undefined)
        {
            if (!intro.will_finish()) return false;
        }
        
        if (!loop.will_finish()) return false;
        
        if (outro != undefined)
        {
            if (!outro.will_finish()) return false;
        }
        
        return true;
    }
    
    finish = function()
    {
        if (!__finished && __VINYL_DEBUG) __vinyl_trace("Finished ", self);
        
        if (intro != undefined) with(intro) finish();
        with(loop) finish();
        if (outro != undefined) with(outro) finish();
        
        __stopping = false;
        __finished = true;
        __current  = undefined;
    }
    
    tick = function()
    {
        if (!__started && !__stopping && !__finished)
        {
            //If we're not started and we're not stopping and we ain't finished, then play!
            play();
        }
        else
        {
            __vinyl_player_common_tick(false);
            
            //Handle fade out
            if (time_fade_out > 0.0)
            {
                if (__stopping && (current_time - __time_stopping > time_fade_out)) finish();
            }
            
            if (__current != undefined)
            {
                with(__current) tick();
                
                if (__current.will_finish())
                {
                    if (__current == intro)
                    {
                        __current = loop;
                        __current.play();
                    }
                    else if (__current == loop)
                    {
                        if (!__stopping)
                        {
                            loop.play();
                        }
                        else if (outro != undefined)
                        {
                            __current = outro;
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
                else if (__started && __stopping && !wait_to_play_outro && (outro != undefined) && (__current != outro))
                {
                    __current.finish();
                    __current = outro;
                    __current.play();
                }
            }
        }
    }
    
    toString = function()
    {
        return "Loop [ " + __vinyl_get_source_name(intro) + "," + __vinyl_get_source_name(loop) + "," + __vinyl_get_source_name(outro) + " ]";
    }
    
    if (__VINYL_DEBUG) __vinyl_trace("Created player ", self);
}