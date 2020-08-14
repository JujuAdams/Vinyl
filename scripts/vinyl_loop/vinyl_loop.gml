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
    
    generate = function(_parent_buss)
    {
        //Pass on either our buss, or our parent's buss, to child players
        var _buss = (buss != undefined)? buss : _parent_buss;
        
        //Generate child players
        var _intro = (__intro != undefined)? __intro.generate(_buss) : undefined;
        var _loop  =                          __loop.generate(_buss);
        var _outro = (__outro != undefined)? __outro.generate(_buss) : undefined;
        
        //Generate our own player
        with(new __vinyl_player_loop(_intro, _loop, _outro))
        {
            __vinyl_player_common_complete(other, _buss);
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
    __vinyl_player_common();
    
    __intro = _intro;
    __loop  = _loop;
    __outro = _outro;
    
    __intro.__parent = self;
    __loop.__parent  = self;
    __outro.__parent = self;
    
    __current = undefined;
    
    play = function()
    {
        //If we have some un-set values, figure them out
        var _parent_gain  = 1.0;
        var _parent_pitch = 1.0;
        if (is_struct(__parent))
        {
            _parent_gain  = __parent.__gain;
            _parent_pitch = __parent.__pitch;
        }
        
        if (__gain  == undefined) __gain  = gain*_parent_gain;
        if (__pitch == undefined) __pitch = pitch*_parent_pitch;
        
        if (__VINYL_DEBUG) __vinyl_trace("Starting player (gain=", __gain, ", pitch=", __pitch, ") ", self);
        
        //Figure out what to play
        __current = (__intro != undefined)? __intro : __loop;
        with(__current) play();
        
        //Set state
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
    
    tick = function(_parent)
    {
        if (!__started && !__stopping)
        {
            play();
        }
        else
        {
            //Update our final gain
            var _parent_gain  = 1.0;
            var _parent_pitch = 1.0;
            if (is_struct(__parent))
            {
                _parent_gain  = __parent.__gain;
                _parent_pitch = __parent.__pitch;
            }
            
            __gain  = gain*_parent_gain;
            __pitch = pitch*_parent_pitch;
            
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