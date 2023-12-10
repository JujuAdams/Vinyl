// Feather disable all

function __VinylClassEffectChain() constructor
{
    static __globalData = __VinylGlobalData();
    
    
    
    __document = undefined;
    __name     = undefined;
    
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
    
    
    
    static __GetName = function()
    {
        return string(__name);
    }
    
    static __Rename = function(_name)
    {
        if (_name == __name) return;
        
        var _effectChainDict = __document.__effectChainDict;
        if (variable_struct_exists(_effectChainDict, _name))
        {
            __VinylTrace("Warning! Cannot rename Vinyl effect chain \"", __name, "\" to \"", _name, "\" as it conflicts with existing effect chain");
            return;
        }
        
        variable_struct_remove(_effectChainDict, __name);
        __name = _name;
        _effectChainDict[$ __name] = self;
        
        __document.__Save();
    }
    
    static __Store = function(_document)
    {
        __document = _document;
        
        _document.__effectChainDict[$ __name] = self;
    }
    
    static __Discard = function()
    {
        variable_struct_remove(__document.__effectChainDict, __name);
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
        
        var _i = 0;
        repeat(__VINYL_EFFECT_BUS_SIZE)
        {
            var _effectStruct = __bus.effects[_i];
            
            var _effectType = (_effectStruct == undefined)? undefined : _effectStruct.type;
            
            ImGui.BeginDisabled(_i >= __VINYL_EFFECT_BUS_SIZE-1);
                if (ImGui.ArrowButton("##Effect " + string(_i) + " Down", ImGuiDir.Down))
                {
                    var _temp = __bus.effects[_i];
                    __bus.effects[_i  ] = __bus.effects[_i+1];
                    __bus.effects[_i+1] = _temp;
                }
            ImGui.EndDisabled();
            
            ImGui.SameLine();
            
            ImGui.BeginDisabled(_i <= 0);
                if (ImGui.ArrowButton("##Effect " + string(_i) + " Up", ImGuiDir.Up))
                {
                    var _temp = __bus.effects[_i];
                    __bus.effects[_i  ] = __bus.effects[_i-1];
                    __bus.effects[_i-1] = _temp;
                }
            ImGui.EndDisabled();
            
            ImGui.SameLine();
            
            var _newType = _effectType;
            ImGui.SetNextItemWidth(150);
            if (ImGui.BeginCombo("##Effect Type Combobox " + string(_i), __VinylEffectToName(_effectType), ImGuiComboFlags.None))
            {
                var _j = 0;
                repeat(array_length(_effectTypeArray))
                {
                    var _effectSelection = _effectTypeArray[_j];
                    if (ImGui.Selectable(__VinylEffectToName(_effectSelection) + "##Effect Selection " + string(_i)))
                    {
                        _newType = _effectSelection;
                    }
                    
                    ++_j;
                }
                
                ImGui.EndCombo();
            }
            
            if (_effectType != _newType)
            {
                var _newEffectStruct = (_newType == undefined)? undefined : audio_effect_create(_newType);
                __bus.effects[_i] = _newEffectStruct;
                
                //Fix up GameMaker's wonky default settings
                if (_newType == AudioEffectType.EQ)
                {
                    static _dataFieldArray = ["locut", "loshelf", "eq1", "eq2", "eq3", "eq4", "hishelf", "hicut"];
                    
                    var _j = 0;
                    repeat(array_length(_dataFieldArray))
                    {
                        _newEffectStruct[$ _dataFieldArray[_j]].bypass = true;
                        ++_j;
                    }
                }
                
                __document.__Save();
            }
            
            if (ImGui.BeginTable("Effect Chain Properties", 2, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.RowBg))
            {
                ImGui.TableSetupColumn("Name",  ImGuiTableColumnFlags.WidthFixed, 80);
                ImGui.TableSetupColumn("Value", ImGuiTableColumnFlags.WidthStretch, 1);
                
                __VinylEffectChainUI(_effectStruct, false, "Bypass");
                
                ImGui.EndTable();
            }
            
            ImGui.NewLine();
            ImGui.NewLine();
            
            ++_i;
        }
    }
}

function __VinylEffectChainUI(_effectStruct, _child, _bypassName)
{
    static _lfoTypeArray = [AudioLFOType.Sine,
                            AudioLFOType.Square,
                            AudioLFOType.Triangle,
                            AudioLFOType.Sawtooth,
                            AudioLFOType.InvSawtooth];
    
    var _effectType = (_effectStruct == undefined)? undefined : _effectStruct.type;
    if (_effectType != undefined)
    {
        var _id = string(ptr(_effectStruct));
        
        ImGui.TableNextRow();
        ImGui.TableSetColumnIndex(0);
        ImGui.Text(_bypassName);
        ImGui.TableSetColumnIndex(1);
        var _newValue = ImGui.Checkbox("##Effect " + _id, _effectStruct.bypass xor _child);
        __document.__Write(_effectStruct, "bypass", _newValue xor _child);
        
        if ((not _effectStruct.bypass) || (not _child))
        {
            ImGui.BeginDisabled(_effectStruct.bypass);
            
            switch(_effectType)
            {
                case AudioEffectType.Bitcrusher:
                    ImGui.TableNextRow();
                    ImGui.TableSetColumnIndex(0);
                    ImGui.Text("Gain");
                    ImGui.TableSetColumnIndex(1);
                    __VINYL_NEXT_UI_FILLS_WIDTH
                    var _newValue = ImGui.SliderFloat("##Effect Gain " + _id, _effectStruct.gain, 0, 4);
                    __document.__Write(_effectStruct, "gain", _newValue);
                    
                    ImGui.TableNextRow();
                    ImGui.TableSetColumnIndex(0);
                    ImGui.Text("Factor");
                    ImGui.TableSetColumnIndex(1);
                    __VINYL_NEXT_UI_FILLS_WIDTH
                    var _newValue = ImGui.SliderFloat("##Effect Factor " + _id, _effectStruct.factor, 0, 100, "%.2f");
                    __document.__Write(_effectStruct, "factor", _newValue);
                    
                    ImGui.TableNextRow();
                    ImGui.TableSetColumnIndex(0);
                    ImGui.Text("Resolution");
                    ImGui.TableSetColumnIndex(1);
                    __VINYL_NEXT_UI_FILLS_WIDTH
                    var _newValue = ImGui.SliderInt("##Effect Resolution " + _id, _effectStruct.resolution, 1, 16);
                    __document.__Write(_effectStruct, "resolution", _newValue);
                    
                    ImGui.TableNextRow();
                    ImGui.TableSetColumnIndex(0);
                    ImGui.Text("Mix");
                    ImGui.TableSetColumnIndex(1);
                    __VINYL_NEXT_UI_FILLS_WIDTH
                    var _newValue = ImGui.SliderFloat("##Effect Mix " + _id, _effectStruct.mix, 0, 1, "%.2f");
                    __document.__Write(_effectStruct, "mix", _newValue);
                break;
                
                case AudioEffectType.Delay:
                    ImGui.TableNextRow();
                    ImGui.TableSetColumnIndex(0);
                    ImGui.Text("Time");
                    ImGui.TableSetColumnIndex(1);
                    __VINYL_NEXT_UI_FILLS_WIDTH
                    var _newValue = ImGui.SliderFloat("##Effect Time " + _id, _effectStruct.time, 0, 3, "%.2f", ImGuiSliderFlags.Logarithmic);
                    __document.__Write(_effectStruct, "time", _newValue);
                    
                    ImGui.TableNextRow();
                    ImGui.TableSetColumnIndex(0);
                    ImGui.Text("Feedback");
                    ImGui.TableSetColumnIndex(1);
                    __VINYL_NEXT_UI_FILLS_WIDTH
                    var _newValue = ImGui.SliderFloat("##Effect Feedback " + _id, _effectStruct.feedback, 0, 1, "%.2f");
                    __document.__Write(_effectStruct, "feedback", _newValue);
                    
                    ImGui.TableNextRow();
                    ImGui.TableSetColumnIndex(0);
                    ImGui.Text("Mix");
                    ImGui.TableSetColumnIndex(1);
                    __VINYL_NEXT_UI_FILLS_WIDTH
                    var _newValue = ImGui.SliderFloat("##Effect Mix " + _id, _effectStruct.mix, 0, 1, "%.2f");
                    __document.__Write(_effectStruct, "mix", _newValue);
                break;
                
                case AudioEffectType.Gain:
                    ImGui.TableNextRow();
                    ImGui.TableSetColumnIndex(0);
                    ImGui.Text("Gain");
                    ImGui.TableSetColumnIndex(1);
                    __VINYL_NEXT_UI_FILLS_WIDTH
                    var _newValue = ImGui.SliderFloat("##Effect Gain " + _id, _effectStruct.gain, 0, 4, "%.2f");
                    __document.__Write(_effectStruct, "gain", max(0, _newValue));
                break;
                
                case AudioEffectType.HPF2:
                case AudioEffectType.LPF2:
                    ImGui.TableNextRow();
                    ImGui.TableSetColumnIndex(0);
                    ImGui.Text("Cutoff");
                    ImGui.TableSetColumnIndex(1);
                    __VINYL_NEXT_UI_FILLS_WIDTH
                    var _newValue = ImGui.SliderFloat("##Effect Cutoff " + _id, _effectStruct.cutoff, 20, 20000, undefined, ImGuiSliderFlags.Logarithmic);
                    __document.__Write(_effectStruct, "cutoff", _newValue);
                    
                    ImGui.TableNextRow();
                    ImGui.TableSetColumnIndex(0);
                    ImGui.Text("Q");
                    ImGui.TableSetColumnIndex(1);
                    __VINYL_NEXT_UI_FILLS_WIDTH
                    var _newValue = ImGui.SliderFloat("##Effect Q " + _id, _effectStruct.q, 1, 100, "%.2f", ImGuiSliderFlags.Logarithmic);
                    __document.__Write(_effectStruct, "q", _newValue);
                break;
                
                case AudioEffectType.Reverb1:
                    ImGui.TableNextRow();
                    ImGui.TableSetColumnIndex(0);
                    ImGui.Text("Size");
                    ImGui.TableSetColumnIndex(1);
                    __VINYL_NEXT_UI_FILLS_WIDTH
                    var _newValue = ImGui.SliderFloat("##Effect Size " + _id, _effectStruct.size, 0, 1, "%.2f");
                    __document.__Write(_effectStruct, "size",_newValue);
                    
                    ImGui.TableNextRow();
                    ImGui.TableSetColumnIndex(0);
                    ImGui.Text("Damping");
                    ImGui.TableSetColumnIndex(1);
                    __VINYL_NEXT_UI_FILLS_WIDTH
                    var _newValue = ImGui.SliderFloat("##Effect Damping " + _id, _effectStruct.damp, 0, 1, "%.2f");
                    __document.__Write(_effectStruct, "damp", _newValue);
                    
                    ImGui.TableNextRow();
                    ImGui.TableSetColumnIndex(0);
                    ImGui.Text("Mix");
                    ImGui.TableSetColumnIndex(1);
                    __VINYL_NEXT_UI_FILLS_WIDTH
                    var _newValue = ImGui.SliderFloat("##Effect Mix " + _id, _effectStruct.mix, 0, 1, "%.2f");
                    __document.__Write(_effectStruct, "mix", _newValue);
                break;
                
                case AudioEffectType.Tremolo:
                    ImGui.TableNextRow();
                    ImGui.TableSetColumnIndex(0);
                    ImGui.Text("Rate");
                    ImGui.TableSetColumnIndex(1);
                    __VINYL_NEXT_UI_FILLS_WIDTH
                    var _newValue = ImGui.SliderFloat("##Effect Rate " + _id, _effectStruct.rate, 0, 20, "%.2f");
                    __document.__Write(_effectStruct, "rate", _newValue);
                    
                    ImGui.TableNextRow();
                    ImGui.TableSetColumnIndex(0);
                    ImGui.Text("Intensity");
                    ImGui.TableSetColumnIndex(1);
                    __VINYL_NEXT_UI_FILLS_WIDTH
                    var _newValue = ImGui.SliderFloat("##Effect Intensity " + _id, _effectStruct.intensity, 0, 1, "%.2f");
                    __document.__Write(_effectStruct, "intensity", _newValue);
                    
                    ImGui.TableNextRow();
                    ImGui.TableSetColumnIndex(0);
                    ImGui.Text("Offset");
                    ImGui.TableSetColumnIndex(1);
                    __VINYL_NEXT_UI_FILLS_WIDTH
                    var _newValue = ImGui.SliderFloat("##Effect Offset " + _id, _effectStruct.offset, 0, 1, "%.2f");
                    __document.__Write(_effectStruct, "offset", _newValue);
                    
                    ImGui.TableNextRow();
                    ImGui.TableSetColumnIndex(0);
                    ImGui.Text("Shape");
                    ImGui.TableSetColumnIndex(1);
                    
                    if (ImGui.BeginCombo("##Effect Shape " + _id, __VinylTremoloShapeToName(_effectStruct.shape), ImGuiComboFlags.None))
                    {
                        var _i = 0;
                        repeat(array_length(_lfoTypeArray))
                        {
                            var _lfoType = _lfoTypeArray[_i];
                            if (ImGui.Selectable(__VinylTremoloShapeToName(_lfoType), (_effectStruct.shape == _lfoType)))
                            {
                                __document.__Write(_effectStruct, "shape", _lfoType);
                            }
                            
                            ++_i;
                        }
                        
                        ImGui.EndCombo();
                    }
                    
                break;
                
                case AudioEffectType.PeakEQ:
                case AudioEffectType.LoShelf:
                case AudioEffectType.HiShelf:
                    ImGui.TableNextRow();
                    ImGui.TableSetColumnIndex(0);
                    ImGui.Text("Frequency");
                    ImGui.TableSetColumnIndex(1);
                    __VINYL_NEXT_UI_FILLS_WIDTH
                    var _newValue = ImGui.SliderFloat("##Effect Frequency " + _id, _effectStruct.freq, 20, 20000, undefined, ImGuiSliderFlags.Logarithmic);
                    __document.__Write(_effectStruct, "freq", _newValue);
                    
                    ImGui.TableNextRow();
                    ImGui.TableSetColumnIndex(0);
                    ImGui.Text("Q");
                    ImGui.TableSetColumnIndex(1);
                    __VINYL_NEXT_UI_FILLS_WIDTH
                    var _newValue = ImGui.SliderFloat("##Effect Q " + _id, _effectStruct.q, 1, 100, "%.2f", ImGuiSliderFlags.Logarithmic);
                    __document.__Write(_effectStruct, "q", _newValue);
                    
                    ImGui.TableNextRow();
                    ImGui.TableSetColumnIndex(0);
                    ImGui.Text("Gain");
                    ImGui.TableSetColumnIndex(1);
                    __VINYL_NEXT_UI_FILLS_WIDTH
                    var _newValue = ImGui.InputFloat("##Effect Gain " + _id, _effectStruct.gain);
                    __document.__Write(_effectStruct, "gain", max(0, _newValue));
                break;
                
                case AudioEffectType.EQ:
                    __VinylEffectChainUI(_effectStruct.locut,   true, "Low Cut"   );
                    __VinylEffectChainUI(_effectStruct.loshelf, true, "Low Shelf" );
                    __VinylEffectChainUI(_effectStruct.eq1,     true, "Peak EQ 1" );
                    __VinylEffectChainUI(_effectStruct.eq2,     true, "Peak EQ 2" );
                    __VinylEffectChainUI(_effectStruct.eq3,     true, "Peak EQ 3" );
                    __VinylEffectChainUI(_effectStruct.eq4,     true, "Peak EQ 4" );
                    __VinylEffectChainUI(_effectStruct.hishelf, true, "High Shelf");
                    __VinylEffectChainUI(_effectStruct.hicut,   true, "High Cut"  );
                break;
            }
            
            ImGui.EndDisabled();
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
    if (not is_struct(_readStruct)) return undefined;
    
    var _effect = __VinylNameToEffect(_readStruct.type);
    
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