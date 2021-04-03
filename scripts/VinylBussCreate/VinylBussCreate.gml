/// @param bussName

function VinylBussCreate(_name)
{
    switch(_name)
    {
        case "master":
        case "gain":
        case "gain_target":
        case "gain_rate":
        case "pitch":
        case "pitch_target":
        case "pitch_rate":
        case "__gain":
        case "__pitch":
        case "__old_gain":
        case "__old_pitch":
            __VinylError("Buss name \"", _name, "\" not permitted");
        break;
    }
    
    with(new __VinylClassBuss())
    {
        if (!variable_struct_exists(global.__vinylBusses, _name))
        {
            variable_struct_set(global.__vinylBusses, _name, self);
            
            if (instanceof(other) == "__VinylClassBuss")
            {
                variable_struct_set(other, _name, self);
            }
            else
            {
                variable_struct_set(VINYL_MASTER, _name, self);
            }
        }
        else
        {
            __VinylError("Buss \"", _name, "\" already exists\nBuss names must be globally unique");
        }
        
        return self;
    }
}

function __VinylClassBuss() constructor
{
    gain         = 1.0;
    gain_target  = 1.0;
    gain_rate    = 0.1;
    
    pitch        = 1.0;
    pitch_target = 1.0;
    pitch_rate   = 0.1;
    
    __gain      = 1.0;
    __pitch     = 1.0;
    __old_gain  = 1.0;
    __old_pitch = 1.0;
    
    static __Tick = function(_parent)
    {
        //Tween to target gain
        if (__old_gain != gain)
        {
            __old_gain  = gain;
            gain_target = gain;
        }
        else if (gain_target != gain)
        {
            gain += clamp(gain_target - gain, -gain_rate, gain_rate);
        }
        
        //Tween to target pitch
        if (__old_pitch != pitch)
        {
            __old_pitch  = pitch;
            pitch_target = pitch;
        }
        else if (pitch_target != pitch)
        {
            pitch += clamp(pitch_target - pitch, -pitch_rate, pitch_rate);
        }
        
        //Calculate our resultant gain
        if (self != VINYL_MASTER)
        {
            __gain  = gain  * _parent.__gain;
            __pitch = pitch * _parent.__pitch;
        }
        else
        {
            __gain  = gain;
            __pitch = pitch;
        }
        
        //Tick our children as well
        var _names = variable_struct_get_names(self);
        var _i = 0;
        repeat(array_length(_names))
        {
            var _child = variable_struct_get(self, _names[_i]);
            if (is_struct(_child)) _child.__Tick(self);
            ++_i;
        }
    }
}