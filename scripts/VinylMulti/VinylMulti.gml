/// @param source
/// @param ...

function VinylMulti()
{
    switch(argument_count)
    {
        case 0: __VinylError("Unsupported number of arguments (", argument_count, ") for VinylMulti()\n(Should be at least 1)"); break;
        
        case 1: return new __VinylPatternMulti(argument[0]); break;
        case 2: return new __VinylPatternMulti(argument[0], argument[1]); break;
        case 3: return new __VinylPatternMulti(argument[0], argument[1], argument[2]); break;
        case 4: return new __VinylPatternMulti(argument[0], argument[1], argument[2], argument[3]); break;
        case 5: return new __VinylPatternMulti(argument[0], argument[1], argument[2], argument[3], argument[4]); break
        
        default: __VinylError("Unsupported number of arguments (", argument_count, ") for VinylMulti()\n(Please add another case to the switch statement)"); break;
    }
}

/// @param source
/// @param ...
function __VinylPatternMulti() constructor
{
    __VinylPatternCommonConstruct();
    
    sources     = array_create(argument_count, undefined);
    synchronize = false;
    loop        = false;
    
    //Copy input sources into the actual array
    var _i = 0;
    repeat(argument_count)
    {
        sources[@ _i] = argument[_i];
        ++_i;
    }
    
    static Play = function()
    {
        var _instance = __Play(true);
        ds_list_add(global.__vinylPlaying, _instance);
        return _instance;
    }
    
    static __Play = function(_direct)
    {
        var _sources = array_create(array_length(sources));
        
        //Patternise and generate sources
        var _i = 0;
        repeat(array_length(_sources))
        {
            var _source = __VinylPatternizeSource(sources[_i]);
            _sources[@ _i] = _source.__Play(false);
            ++_i;
        }
        
        //Generate our own player
        with(new __VinyPlayerMulti(_sources, synchronize, loop))
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
        return "Multi " + string(sources);
    }
    
    if (__VINYL_DEBUG) __VinylTrace("Created pattern ", self);
}

/// @param sources
function __VinyPlayerMulti(_sources, _synchronize, _loop) constructor
{
    __VinylPlayerCommonConstruct();
    
    synchronize = _synchronize;
    loop        = _loop;
    
    sources = _sources;
    
    var _i = 0;
    repeat(array_length(sources))
    {
        if (is_struct(sources[_i])) sources[_i].__parent = self;
        ++_i;
    }
    
    static __Reset = function()
    {
        __VinylPlayerCommonReset();
        
        var _i = 0;
        repeat(array_length(sources))
        {
            if (is_struct(sources[_i])) sources[_i].__Reset();
            ++_i;
        }
    }
    
    __Reset();
    
    static __Play = function()
    {
        __VinylPlayerCommonPlay(false);
        
        if (__VINYL_DEBUG) __VinylTrace("Playing ", self, " (buss=\"", buss_name, "\", gain=", __gain, ", pitch=", __pitch, ")");
        
        //Figure out what to play
        var _i = 0;
        repeat(array_length(sources))
        {
            with(sources[_i]) __Play();
            ++_i;
        }
    }
    
    static GetPosition = function()
    {
        if (!__started || __finished) return undefined;
        
        var _any_valid = false;
        
        var _max_time = 0;
        var _i = 0;
        repeat(array_length(sources))
        {
            var _time = sources[_i].GetPosition();
            if (_time != undefined)
            {
                _any_valid = true;
                _max_time = max(_max_time, _time);
            }
            
            ++_i;
        }
        
        return _any_valid? _max_time : undefined;
    }
    
    /// @param time
    static SetPosition = function(_time)
    {
        if ((_time != undefined) && __started && !__finished)
        {
            var _i = 0;
            repeat(array_length(sources))
            {
                sources[_i].SetPosition(_time);
                ++_i;
            }
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
    
    static Stop = function()
    {
        if (!__stopping && !__finished)
        {
            if (__VINYL_DEBUG) __VinylTrace("Stopping ", self);
            
            var _i = 0;
            repeat(array_length(sources))
            {
                with(sources[_i]) Stop(false);
                ++_i;
            }
            
            __stopping = true;
            __time_stopping = current_time;
        }
    }
    
    static WillFinish = function()
    {
        var _i = 0;
        repeat(array_length(sources))
        {
            if (!sources[_i].WillFinish()) return false;
            ++_i;
        }
        
        return true;
    }
    
    static StopNow = function()
    {
        if (__VINYL_DEBUG) __VinylTrace("Finished ", self);
        
        var _i = 0;
        repeat(array_length(sources))
        {
            with(sources[_i]) StopNow();
            ++_i;
        }
        
        __stopping = false;
        __finished = true;
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
            if (__stopping && (current_time - __time_stopping > time_fade_out)) StopNow();
            
            if (synchronize)
            {
                var _finished = false;
                var _time = undefined;
                
                if (loop)
                {
                    var _i = 0;
                    repeat(array_length(sources))
                    {
                        with(sources[_i])
                        {
                            __Tick(); //Update the instances we're currently playing
                            if (_time == undefined) _time = GetPosition() else SetPosition(_time);
                            if (WillFinish()) _finished = true;
                        }
                        
                        ++_i;
                    }
                    
                    if (_finished)
                    {
                        var _i = 0;
                        repeat(array_length(sources))
                        {
                            sources[_i].__Play();
                            ++_i;
                        }
                    }
                }
                else
                {
                    var _i = 0;
                    repeat(array_length(sources))
                    {
                        with(sources[_i])
                        {
                            __Tick(); //Update the instances we're currently playing
                            if (_time == undefined) _time = GetPosition() else SetPosition(_time);
                            if (__finished) _finished = true;
                        }
                        
                        ++_i;
                    }
                    
                    if (_finished) StopNow();
                }
            }
            else
            {
                if (loop)
                {
                    var _i = 0;
                    repeat(array_length(sources))
                    {
                        with(sources[_i])
                        {
                            __Tick(); //Update the instances we're currently playing
                            if (WillFinish()) __Play();
                        }
                    
                        ++_i;
                    }
                }
                else
                {
                    var _finished = true;
                    var _i = 0;
                    repeat(array_length(sources))
                    {
                        with(sources[_i])
                        {
                            __Tick(); //Update the instances we're currently playing
                            if (!__finished) _finished = false;
                        }
                    
                        ++_i;
                    }
                    
                    if (_finished) StopNow();
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
        return "Multi " + string(sources);
    }
    
    if (__VINYL_DEBUG) __VinylTrace("Created player ", self);
}