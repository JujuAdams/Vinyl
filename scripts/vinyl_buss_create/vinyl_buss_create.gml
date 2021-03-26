/// @param bussName

function vinyl_buss_create(_name)
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
            __vinyl_error("Buss name \"", _name, "\" not permitted");
        break;
    }
    
    with(new __vinyl_class_buss())
    {
        if (!variable_struct_exists(global.__vinyl_busses, _name))
        {
            variable_struct_set(global.__vinyl_busses, _name, self);
            
            if (instanceof(other) == "__vinyl_class_buss")
            {
                variable_struct_set(other, _name, self);
            }
            else
            {
                variable_struct_set(vinyl_master, _name, self);
            }
        }
        else
        {
            __vinyl_error("Buss \"", _name, "\" already exists\nBuss names must be globally unique");
        }
        
        return self;
    }
}

function __vinyl_class_buss() constructor
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
    
    static tick = function(_parent)
    {
        //Tween to target gain
        if (__old_gain != gain)
        {
            __old_gain  = gain;
            gain_target = gain;
        }
        else if (gain_target != gain)
        {
            gain += clamp( gain_target - gain, -gain_rate, gain_rate);
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
        if (self != vinyl_master)
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
            if (is_struct(_child)) _child.tick(self);
            ++_i;
        }
    }
}