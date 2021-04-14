#region Internal Macro Definitions

#macro __VINYL_VERSION  "2.0.0"
#macro __VINYL_DATE     "2021/04/10"

#macro VINYL_LIB       global.__vinylLibrary
#macro VINYL_LIBRARY   global.__vinylLibrary

__VinylTrace("Welcome to Vinyl by @jujuadams! This is version " + __VINYL_VERSION + ", " + __VINYL_DATE);

#endregion

global.__vinylPlaying         = ds_list_create(); //TODO - Replace this with an array
global.__vinylGlobalAssetGain = ds_map_create();

VINYL_LIB = {};

//Iterate over all audio assets
var _i = 0;
repeat(9999)
{
    if (!audio_exists(_i)) break;
    global.__vinylGlobalAssetGain[? _i] = audio_sound_get_gain(_i);
    ++_i;
}
 
function VinylSystemEndStep()
{
    var _i = 0;
    repeat(ds_list_size(global.__vinylPlaying))
    {
        with(global.__vinylPlaying[| _i])
        {
            __Tick();
            
            if (__finished)
            {
                if (VINYL_DEBUG) __VinylTrace("Deleted ", self);
                ds_list_delete(global.__vinylPlaying, _i);
            }
            else
            {
                ++_i;
            }
        }
    }
}

function __VinylPatternCommonConstruct(_instanceConstructor)
{
    __instanceConstructor = _instanceConstructor;
    
    __gainMin = 1.0;
    __gainMax = 1.0;
    
    __pitchMin = 1.0;
    __pitchMax = 1.0;
    
    __timeFadeIn  = undefined;
    __timeFadeOut = undefined;
}

function __VinylInstanceCommonConstruct(_pattern)
{
    __pattern = _pattern;
    __parent  = undefined;
    
    __gain       = 1.0;
    __gainRate   = VINYL_DEFAULT_GAIN_RATE;
    __gainTarget = undefined;
    
    __pitch       = 1.0;
    __pitchRate   = VINYL_DEFAULT_PITCH_RATE;
    __pitchTarget = undefined;
    
    __timeFadeIn  = undefined;
    __timeFadeOut = undefined;
    
    __started      = false;
    __timeStarted  = -1;
    __stopping     = false;
    __timeStopping = -1;
    __finished     = false;
}

function __VinylInstancePatternizeAll(_parentInstance, _patternSources)
{
    var _instance_sources = array_create(array_length(_patternSources));
    
    //Patternise and generate the sources
    var _i = 0;
    repeat(array_length(_patternSources))
    {
        var _pattern = _patternSources[_i];
        if (_pattern == undefined)
        {
            _instance_sources[@ _i] = undefined;
        }
        else
        {
            var _instance = __VinylPatternizeSource(_pattern).__Play();
            _instance.__parent = _parentInstance;
            _instance_sources[@ _i] = _instance;
        }
        
        ++_i;
    }
    
    return _instance_sources;
}

function __VinylInstanceCommonReset()
{
    __started      = false;
    __timeStarted  = -1;
    __stopping     = false;
    __timeStopping = -1;
    __finished     = false;
    
    __gain  = undefined;
    __pitch = undefined;
    
    if (__pattern != undefined)
    {
        if (__pattern.__timeFadeIn  != undefined) __timeFadeIn  = __pattern.__timeFadeIn;
        if (__pattern.__timeFadeOut != undefined) __timeFadeOut = __pattern.__timeFadeOut;
        
        //Randomise the gain/pitch as is appropriate
        __gain  = random_range(__pattern.__gainMin , __pattern.__gainMax );
        __pitch = random_range(__pattern.__pitchMin, __pattern.__pitchMax);
    }
}

function __VinylInstanceCommonPlay()
{
    Kill();
    __Reset();
    
    //Set state
    __started = true;
    __timeStarted = current_time;
    
    __VinylInstanceCommonTick();
    
    if (VINYL_DEBUG) __VinylTrace("Playing ", self, " (gain=", __gain, ", pitch=", __pitch, ")");
}

function __VinylInstanceCommonTick()
{
    var _finalGain  = 1.0;
    var _finalPitch = 1.0;
    
    //Find our parent's gain and pitch
    if (is_struct(__parent))
    {
        _finalGain  *= __parent.__gain;
        _finalPitch *= __parent.__pitch;
    }
    
    //Calculate and apply the fade gain
    if (!__finished)
    {
        if (__timeFadeIn > 0)
        {
            _finalGain *= clamp((current_time - __timeStarted) / __timeFadeIn, 0.0, 1.0);
        }
        
        if (__stopping && (__timeFadeOut > 0))
        {
            _finalGain *= 1.0 - clamp((current_time - __timeStopping) / __timeFadeOut, 0.0, 1.0);
        }
    }
    
    //If our gain or pitch targets are undefined then we should set them!
    if (__gainTarget  == undefined) __gainTarget  = __gain;
    if (__pitchTarget == undefined) __pitchTarget = __pitch;
    
    //Tween to the gain/pitch target
    if (__gain  != __gainTarget ) gain  += clamp(__gainTarget  - __gain , -__gainRate , __gainRate );
    if (__pitch != __pitchTarget) pitch += clamp(__pitchTarget - __pitch, -__pitchRate, __pitchRate);
    
    //Set our final gain
    __gain  *= _finalGain;
    __pitch *= _finalPitch;
}

/// @param value
function __VinylGetSourceName(_value)
{
    if (is_numeric(_value))
    {
        return audio_get_name(_value);
    }
    else
    {
        return string(_value);
    }
}

/// @param source
function __VinylPatternizeSource(_source)
{
    if (is_numeric(_source))
    {
        //TODO - Cache this
        return new __VinylPatternBasic(_source);
    }
    else
    {
        return _source;
    }
}

#region Utility

/// @param [value...]
function __VinylTrace()
{
	var _string = "";
	var _i = 0;
	repeat(argument_count)
	{
	    _string += string(argument[_i]);
	    ++_i;
	}

	show_debug_message(string_format(current_time, 8, 0) + " Vinyl: " + _string);

	return _string;
}

/// @param [value...]
function __VinylError()
{
	var _string = "";
    
	var _i = 0;
	repeat(argument_count)
	{
	    _string += string(argument[_i]);
	    ++_i;
	}
    
	show_error("Vinyl:\n" + _string + "\n ", false);
    
	return _string;
}

/// @param array
/// @param index
function __VinylArrayDelete(_array, _index)
{
    var _copy_size = array_length(_array) - (_index+1);
    if ((_index < 0) || (_copy_size < 0)) throw "Index " + string(_index) + " is greater than maximum array index (" + string(array_length(_array)-1) + ")";
    
    var _new_array = array_create(_copy_size);
    array_copy(_new_array, 0, _array, _index+1, _copy_size);
    array_copy(_array, _index, _new_array, 0, _copy_size);
    array_resize(_array, array_length(_array)-1);
}

#endregion



#region Pattern common methods

function __VinylPatternPlay()
{
    with(new __instanceConstructor(self))
    {
        __Reset();
        ds_list_add(global.__vinylPlaying, self);
        return self;
    }
}

//Gain access
function __VinylPatternGainSet()
{
    var _min = ((argument_count > 0) && (argument[0] != undefined))? argument[0] : 1.0;
    var _max = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : _min;
    
    __gainMin = _min;
    __gainMax = _max;
    
    return self;
}

function __VinylPatternGainGet()
{
    return { mini : __gainMin, maxi : __gainMax };
}

//Pitch access
function __VinylPatternPitchSet()
{
    var _min = ((argument_count > 0) && (argument[0] != undefined))? argument[0] : 1.0;
    var _max = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : _min;
    
    __pitchMin = _min;
    __pitchMax = _max;
    
    return self;
}

function __VinylPatternPitchGet()
{
    return { mini : __pitchMin, maxi : __pitchMax };
}

//Fade time access
function __VinylPatternFadeTimeSet(_inTime, _outTime)
{
    __timeFadeIn  = _inTime;
    __timeFadeOut = _outTime;
    
    return self;
}

function __VinylPatternFadeTimeGet()
{
    return { in : __timeFadeIn, out : __timeFadeOut };
}

#endregion



#region Sound instance common methods

//Gain access
function __VinylInstanceGainSet(_value)
{
    __gain = _value;
        
    return self;
}

function __VinylInstanceGainTargetSet(_target, _rate)
{
    __gainTarget = _target;
    __gainRate = _rate;
        
    return self;
}

function __VinylInstanceGainGet()
{
    return __gain;
}

//Pitch access
function __VinylInstancePitchSet(_value)
{
    __pitch = _value;
        
    return self;
}

function __VinylInstancePitchTargetSet(_target, _rate)
{
    __pitchTarget = _target;
    __pitchRate = _rate;
        
    return self;
}

function __VinylInstancePitchGet()
{
    return __pitch;
}

//Fade time access
function __VinylInstanceFadeTimeSet(_inTime, _outTime)
{
    __timeFadeIn  = _inTime;
    __timeFadeOut = _outTime;
        
    return self;
}

function __VinylInstanceFadeTimeGet()
{
    return { in : __timeFadeIn, out : __timeFadeOut };
}

function __VinylInstancePatternGet()
{
    return __pattern;
}

function __VinylInstanceIsStopping()
{
    return __stopping;
}

function __VinylInstanceIsFinished()
{
    return __finished;
}

#endregion



#region Random / queue / multi methods

function __VinylInstanceSourceGet(_index)
{
    if ((_index < 0) || (_index >= array_length(__sources))) return undefined;
    return __sources[_index];
}
    
function __VinylInstanceSourcesCountGet()
{
    return array_length(__sources);
}

function __VinylInstanceSourcesArrayGet()
{
    var _array = array_create(array_length(__sources));
    array_copy(_array, 0, __sources, 0, array_length(__sources));
    return _array;
}

function __VinylInstanceSourceFindIndex(_source)
{
    _source = __VinylPatternizeSource(_source);
    
    var _i = 0;
    repeat(array_length(__sources))
    {
        if (__sources[_i].PatternGet() == _source) return _i;
        ++_i;
    }
    
    return undefined;
}

function __VinylInstanceInstanceFindIndex(_instance)
{
    var _i = 0;
    repeat(array_length(__sources))
    {
        if (__sources[_i] == _instance) return _i;
        ++_i;
    }
    
    return undefined;
}
    
#endregion