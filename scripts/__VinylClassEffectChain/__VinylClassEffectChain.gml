// Feather disable all

function __VinylClassEffectChain() constructor
{
    static __globalData = __VinylGlobalData();
    
    
    
    __name = undefined;
    
    if (__name == "main")
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
    
    
    
    static __Store = function(_document)
    {
        _document.__effectChainDict[$ __name] = self;
    }
    
    static __Discard = function(_document)
    {
        variable_struct_remove(_document.__effectChainDict, __name);
        __document.__Save();
    }
    
    static __Serialize = function(_struct)
    {
        var _array = array_create(__VINYL_EFFECT_BUS_SIZE, undefined);
        
        _struct.name        = __name;
        _struct.effectArray = _array;
        
        var _i = 0;
        repeat(__VINYL_EFFECT_BUS_SIZE)
        {
            _array[_i] = __VinylEffectChainSerialize(__bus.effects[_i]);
            ++_i;
        }
    }
    
    static __Deserialize = function(_struct)
    {
        __name = _struct.name;
        
        var _effectArray = _struct.effectArray;
        
        var _i = 0;
        repeat(array_length(_effectArray))
        {
            var _effect = __VinylEffectChainDeserialize(_effectArray[_i], __bus.effects[_i]);
            __bus.effects[_i] = _effect;
            ++_i;
        }
        
        //Finish out the rest of the effect chain with <undefined>
        repeat(__VINYL_EFFECT_BUS_SIZE - _i)
        {
            __bus.effects[_i] = undefined;
            ++_i;
        }
    }
    
    
    
    static toString = function()
    {
        return "<effect chain " + string(__name) + ">";
    }
    
    static __GetEmitter = function()
    {
        return __emitter;
    }
    
    static __VoiceAdd = function(_id)
    {
        //Do nothing
    }
    
    static __VoiceRemove = function(_id)
    {
        //Do nothing
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
    
    static __BuildPropertyUI = function()
    {
        var _funcCombobox = function(_oldEffect, _i)
        {
            var _newEffect = _oldEffect;
            
            if (ImGui.BeginCombo("##Effect Type Combobox " + string(_i), __VinylEffectToName(_oldEffect), ImGuiComboFlags.None))
            {
                static _effectTypeArray = [undefined,
                                            AudioEffectType.Bitcrusher,
                                            AudioEffectType.Delay,
                                            AudioEffectType.Gain,
                                            AudioEffectType.HPF2,
                                            AudioEffectType.LPF2,
                                            AudioEffectType.Reverb1,
                                            AudioEffectType.Tremolo,
                                            AudioEffectType.PeakEQ,
                                            AudioEffectType.LoShelf,
                                            AudioEffectType.HiShelf,
                                            AudioEffectType.EQ];
                    
                var _j = 0;
                repeat(array_length(_effectTypeArray))
                {
                    var _effectType = _effectTypeArray[_j];
                    if (ImGui.Selectable(__VinylEffectToName(_effectType) + "##" + string(_i)))
                    {
                        _newEffect = _effectType;
                    }
                        
                    ++_j;
                }
                    
                ImGui.EndCombo();
            }
                
            if (_oldEffect != _newEffect)
            {
                    
            }
        }
        
        var _i = 0;
        repeat(__VINYL_EFFECT_BUS_SIZE)
        {
            var _effectStruct = __bus.effects[_i];
            
            var _effectName = __VinylEffectToName((_effectStruct == undefined)? undefined : _effectStruct.type);
            if (ImGui.CollapsingHeader("Effect " + string(_i+1) + " - " + _effectName))
            {
                _funcCombobox((_effectStruct == undefined)? undefined : _effectStruct.type, _i);
                
                switch(_effectStruct.type)
                {
                    case AudioEffectType.Bitcrusher:
                    break;
                    
                    case AudioEffectType.Delay:
                    break;
                    
                    case AudioEffectType.Gain:
                    break;
                    
                    case AudioEffectType.HPF2:
                    break;
                    
                    case AudioEffectType.LPF2:
                    break;
                    
                    case AudioEffectType.Reverb1:
                    break;
                    
                    case AudioEffectType.Tremolo:
                    break;
                    
                    case AudioEffectType.LoShelf:
                    break;
                    
                    case AudioEffectType.HiShelf:
                    break;
                    
                    case AudioEffectType.EQ:
                    break;
                }
                
                ++_i;
            }
        }
    }
}



function __VinylEffectChainSerialize(_effect)
{
    if (_effect == undefined) return undefined;
    
    var _result = {
        type: __VinylEffectToName(_effect.type),
    };
    
    var _effectDataNameArray = variable_struct_get_names(_effect);
    var _i = 0;
    repeat(array_length(_effectDataNameArray))
    {
        var _effectVar = _effectDataNameArray[_i];
        if (_effectVar != "type")
        {
            var _value = _effect[$ _effectVar];
            
            //Special case for tremolo shape
            switch(_effectVar)
            {
                case "shape":
                    _result[$ _effectVar] = __VinylNameToTremoloShape(_value);
                break;
                
                case "locut":
                case "loshelf":
                case "eq1":
                case "eq2":
                case "eq3":
                case "eq4":
                case "hishelf":
                case "hicut":
                    _result[$ _effectVar] = __VinylEffectChainSerialize(_effect[$ _effectVar]);
                break;
                
                default:
                    _result[$ _effectVar] = _value;
                break;
            }
        }
        
        ++_i;
    }
    
    return _result;
}

function __VinylEffectChainDeserialize(_readStruct, _existingEffect)
{
    var _effect = __VinylEffectToName(_readStruct.type);
    
    //If the old effect is of a different type, make a new one
    if ((_existingEffect == undefined) || (_existingEffect.type != _effect))
    {
        _existingEffect = audio_effect_create(_effect);
    }
    
    //Set values for the effect
    var _effectDataNameArray = variable_struct_get_names(_readStruct);
    var _i = 0;
    repeat(array_length(_effectDataNameArray))
    {
        var _effectVar = _effectDataNameArray[_i];
        if (_effectVar != "type")
        {
            var _value = _readStruct[$ _effectVar];
            
            //Special case for tremolo shape
            switch(_effectVar)
            {
                case "shape":
                    _existingEffect[$ _effectVar] = __VinylNameToTremoloShape(_value);
                break;
                
                case "locut":
                case "loshelf":
                case "eq1":
                case "eq2":
                case "eq3":
                case "eq4":
                case "hishelf":
                case "hicut":
                    __VinylEffectChainDeserialize(_value, _existingEffect[$ _effectVar]);
                break;
                
                default:
                    _existingEffect[$ _effectVar] = _value;
                break;
            }
        }
        
        ++_i;
    }
    
    return _existingEffect;
}