#region Internal Macro Definitions

#macro __VINYL_VERSION  "1.0.3"
#macro __VINYL_DATE     "2021/03/26"

#macro __VINYL_DEBUG  false

#macro VINYL_LIB       global.__vinylLibrary
#macro VINYL_LIBRARY   global.__vinylLibrary
#macro VINYL_MASTER    (global.__vinylBusses.master)

__VinylTrace("Welcome to Vinyl by @jujuadams! This is version " + __VINYL_VERSION + ", " + __VINYL_DATE);

#endregion

global.__vinylPlaying         = ds_list_create(); //TODO - Replace this with an array
global.__vinylGlobalAssetGain = ds_map_create();
global.__vinylBusses          = {};

VINYL_LIB    = {};
VINYL_MASTER = new __VinylClassBuss();

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
    VINYL_MASTER.__Tick();
    
    var _i = 0;
    repeat(ds_list_size(global.__vinylPlaying))
    {
        with(global.__vinylPlaying[| _i])
        {
            __Tick();
            
            if (__finished)
            {
                if (__VINYL_DEBUG) __VinylTrace("Deleted ", self);
                ds_list_delete(global.__vinylPlaying, _i);
            }
            else
            {
                ++_i;
            }
        }
    }
}

function __VinylPatternCommonConstruct()
{
    __bussName = undefined;
    
    __gainMin = 1.0;
    __gainMax = 1.0;
    
    __pitchMin = 1.0;
    __pitchMax = 1.0;
    
    __timeFadeIn  = undefined;
    __timeFadeOut = undefined;
}

function __VinylPlayerCommonConstruct()
{
    __bussName = undefined;
    
    __gain       = 1.0;
    __gainRate   = VINYL_DEFAULT_GAIN_RATE;
    __gainTarget = undefined;
    
    __pitch       = 1.0;
    __pitchRate   = VINYL_DEFAULT_PITCH_RATE;
    __pitchTarget = undefined;
    
    __timeFadeIn  = undefined;
    __timeFadeOut = undefined;
    
    __buss    = undefined;
    __pattern = undefined;
    __parent  = undefined;
    
    __started      = false;
    __timeStarted  = -1;
    __stopping     = false;
    __timeStopping = -1;
    __finished     = false;
}

function __VinylPlayerCommonReset()
{
    __started      = false;
    __timeStarted  = -1;
    __stopping     = false;
    __timeStopping = -1;
    __finished     = false;
    
    __buss  = undefined;
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

/// @param useBuss
function __VinylPlayerCommonPlay(_useBuss)
{
    StopNow();
    __Reset();
    
    //Set state
    __started = true;
    __timeStarted = current_time;
    
    __VinylPlayerCommonTick(_useBuss);
}

/// @param useBuss
function __VinylPlayerCommonTick(_useBuss)
{
    var _finalGain  = 1.0;
    var _finalPitch = 1.0;
    
    //Find our parent's gain, pitch, and buss
    if (is_struct(__parent))
    {
        _finalGain  *= __parent.__gain;
        _finalPitch *= __parent.__pitch;
        __buss = __parent.__buss;
    }
    else
    {
        //If we have no parent, find our own buss
        __buss = VinylBussGet(__bussName);
    }
    
    //If we want to factor in our buss' gain/pitch, do so here
    if (_useBuss)
    {
        if (!is_struct(__buss)) __buss = VINYL_MASTER;
        _finalGain  *= __buss.__gain;
        _finalPitch *= __buss.__pitch;
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