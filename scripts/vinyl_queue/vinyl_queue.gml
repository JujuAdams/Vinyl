/// @param source
/// @param ...

function vinyl_queue()
{
    switch(argument_count)
    {
        case 0: __vinyl_error("Unsupported number of arguments (", argument_count, ") for vinyl_queue()\n(Should be at least 1)"); break;
        
        case 1: return new __vinyl_pattern_queue(argument[0]); break;
        case 2: return new __vinyl_pattern_queue(argument[0], argument[1]); break;
        case 3: return new __vinyl_pattern_queue(argument[0], argument[1], argument[2]); break;
        case 4: return new __vinyl_pattern_queue(argument[0], argument[1], argument[2], argument[3]); break;
        case 5: return new __vinyl_pattern_queue(argument[0], argument[1], argument[2], argument[3], argument[4]); break
        
        default: __vinyl_error("Unsupported number of arguments (", argument_count, ") for vinyl_queue()\n(Please add another case to the switch statement)"); break;
    }
}

/// @param source
/// @param ...
function __vinyl_pattern_queue() constructor
{
    __vinyl_pattern_common();
    
    __sources = array_create(argument_count, undefined);
    var _i = 0;
    repeat(argument_count)
    {
        __sources[@ _i] = __vinyl_patternize_source(argument[_i]);
        ++_i;
    }
    
    generate = function(_parent_buss)
    {
        //Pass on either our buss, or our parent's buss, to child players
        var _buss = (buss != undefined)? buss : _parent_buss;
        
        //Generate child players
        var _sources = array_create(array_length(__sources));
        var _i = 0;
        repeat(array_length(__sources))
        {
            _sources[@ _i] = __sources[_i].generate(_parent_buss);
            ++_i;
        }
        
        //Generate our own player
        with(new __vinyl_player_queue(_sources))
        {
            __vinyl_player_common_complete(other, _buss);
            return self;
        }
    }
    
    toString = function()
    {
        return "Queue " + string(__sources);
    }
    
    if (__VINYL_DEBUG) __vinyl_trace("Created pattern ", self);
}

/// @param sources
function __vinyl_player_queue(_sources) constructor
{
    __vinyl_player_common();
    
    __sources = _sources;
    __index   = undefined;
    __current = undefined;
    
    var _i = 0;
    repeat(array_length(__sources))
    {
        __sources[_i].__parent = self;
        ++_i;
    }
    
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
        if (__index == undefined)
        {
            __index = 0;
        }
        else
        {
            __index = (__index + 1) mod array_length(__sources);
        }
        
        __current = __sources[__index];
        with(__current) play();
        
        //Set state
        __started = true;
        __finished = false;
    }
    
    stop = function()
    {
        if (__VINYL_DEBUG) __vinyl_trace(self, " stopping");
        
        with(__current) stop();
        
        __stopping = true;
    }
    
    stop_now = function()
    {
        if (__VINYL_DEBUG) __vinyl_trace(self, " finished");
        
        var _i = 0;
        repeat(array_length(__sources))
        {
            with(__sources[_i]) stop_now();
            ++_i;
        }
        
        __stopping = false;
        __finished = true;
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
            
            //Update the instance we're currently playing
            with(__current) tick();
            
            if (!__stopping)
            {
                if (__current.__stopping || __current.__finished) play();
            }
            else
            {
                if (__current.__finished) stop_now();
            }
        }
    }
    
    toString = function()
    {
        return "Queue " + string(__sources);
    }
    
    if (__VINYL_DEBUG) __vinyl_trace("Created player ", self);
}