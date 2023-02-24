/// @param name

function __VinylClassEffectChain(_name) constructor
{
    static __globalData = __VinylGlobalData();
    
    
    
    __name = _name;
    
    if (_name == "main")
    {
        __bus     = audio_bus_main;
        __emitter = undefined;
    }
    else
    {
        __bus = audio_bus_create();
        
        audio_falloff_set_model(audio_falloff_none);
        __emitter = audio_emitter_create();
        audio_emitter_position(__emitter, __globalData.__listenerX, __globalData.__listenerY, 0);
        audio_emitter_velocity(__emitter, 0, 0, 0);
        audio_emitter_gain(__emitter, 1);
        audio_emitter_falloff(__emitter, 1000, 1001, 1);
        audio_emitter_bus(__emitter, __bus);
        audio_falloff_set_model(__VINYL_FALLOFF_MODEL);
    }
    
    
    
    static toString = function()
    {
        return "<effect chain " + string(__name) + ">";
    }
    
    static __GetEmitter = function()
    {
        return __emitter;
    }
    
    static __InstanceAdd = function()
    {
        //Do nothing
    }
    
    static __Update = function(_busEffectArray, _knobDict)
    {
        var _i = 0;
        repeat(array_length(_busEffectArray))
        {
            var _effectData = _busEffectArray[_i];
            var _effectType = string_lower(_effectData.type);
            
            if (_effectType == "bitcrusher")
            {
                var _effect = audio_effect_create(AudioEffectType.Bitcrusher);
            }
            else if (_effectType == "delay")
            {
                var _effect = audio_effect_create(AudioEffectType.Delay);
            }
            else if (_effectType == "gain")
            {
                var _effect = audio_effect_create(AudioEffectType.Gain);
            }
            else if ((_effectType == "hpf") || (_effectType == "hpf2"))
            {
                var _effect = audio_effect_create(AudioEffectType.HPF2);
            }
            else if ((_effectType == "lpf") || (_effectType == "lpf2"))
            {
                var _effect = audio_effect_create(AudioEffectType.LPF2);
            }
            else if ((_effectType == "reverb") || (_effectType == "reverb1"))
            {
                var _effect = audio_effect_create(AudioEffectType.Reverb1);
            }
            else if (_effectType == "tremolo")
            {
                var _effect = audio_effect_create(AudioEffectType.Tremolo);
            }
            else
            {
                __VinylError("Effect type \"", _effectType, "\" not recognised (", self, " index=", _i, ")");
            }
            
            if (_effect != undefined)
            {
                var _effectDataNameArray = variable_struct_get_names(_effectData);
                var _j = 0;
                repeat(array_length(_effectDataNameArray))
                {
                    var _effectDataField = _effectDataNameArray[_j];
                    if (_effectDataField != "type")
                    {
                        var _value = _effectData[$ _effectDataField];
                        
                        if (_effectDataField == "shape")
                        {
                            if (_value == "sine")
                            {
                                _effect[$ _effectDataField] = AudioLFOType.Sine;
                            }
                            else if (_value == "square")
                            {
                                _effect[$ _effectDataField] = AudioLFOType.Square;
                            }
                            else if (_value == "triangle")
                            {
                                _effect[$ _effectDataField] = AudioLFOType.Triangle;
                            }
                            else if (_value == "sawtooth")
                            {
                                _effect[$ _effectDataField] = AudioLFOType.Sawtooth;
                            }
                            else if (_value == "inverse sawtooth")
                            {
                                _effect[$ _effectDataField] = AudioLFOType.InvSawtooth;
                            }
                            else
                            {
                                __VinylError("Tremolo effect shape type \"", _value, "\" not recognised");
                            }
                        }
                        else
                        {
                            if (is_string(_value))
                            {
                                if (string_char_at(_value, 1) == "@")
                                {
                                    var _knobName = string_delete(_value, 1, 1);
                                    var _knob = _knobDict[$ _knobName];
                                    if (!is_struct(_knob)) __VinylError("Error in ", self, " for effect ", _i, "'s ", _effectDataField, " property\nKnob \"", _knobName, "\" doesn't exist");
                                    
                                    _knob.__TargetCreate(_effect, _effectDataField);
                                    _value = _knob.__actualValue; //Set parameter to the current value of the knob
                                }
                                else
                                {
                                    __VinylError("Error in ", self, " for effect ", _i, "'s ", _effectDataField, " property\nEffect parameters must be a number or a knob name");
                                }
                            }
                            
                            _effect[$ _effectDataField] = _value;
                        }
                    }
                    
                    ++_j;
                }
                
                __bus.effects[_i] = _effect;
                if (VINYL_DEBUG_LEVEL >= 2) __VinylTrace("Effect bus ", __bus, " effects[", _i, "] = ", json_stringify(_effect));
            }
            
            ++_i;
        }
        
        //Finish out the rest of the effect chain with <undefined>
        repeat(8 - _i)
        {
            __bus.effects[_i] = undefined;
            if (VINYL_DEBUG_LEVEL >= 2) __VinylTrace("Effect bus ", __bus, " effects[", _i, "] = undefined");
            
            ++_i;
        }
    }
    
    static __Destroy = function()
    {
        if (__emitter != undefined)
        {
            audio_emitter_free(__emitter);
            __emitter = undefined;
        }
    }
    
    static __UpdatePosition = function()
    {
        //Keep this emitter right underneath the listener
        if (__emitter != undefined) audio_emitter_position(__emitter, __globalData.__listenerX, __globalData.__listenerY, 0);
    }
}