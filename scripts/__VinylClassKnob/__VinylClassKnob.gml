// Feather disable all

function __VinylClassKnob() constructor
{
    __name = undefined;
    
    __valueDefault = 0;
    __valueReset   = true;
    __valueParam   = 0;
    __valueInput   = 0;
    __valueOutput  = 0;
    
    __targetArray = [];
    
    __unlimited    = true;
    __inputRange   = [0, 1];
    __outputRange  = [0, 1];
    __defaultValue = 1;
    
    
    
    static __Store = function(_document)
    {
        _document.__knobDict[$ __name] = self;
    }
    
    static __Discard = function(_document)
    {
        variable_struct_remove(_document.__knobDict, __name);
    }
    
    
    
    static toString = function()
    {
        return "<knob " + __name + ">";
    }
    
    static __TargetCreate = function(_scope, _property, _rangeLo, _rangeHi)
    {
        array_push(__targetArray, new __VinylClassKnobTarget(_scope, _property, _rangeLo, _rangeHi));
    }
    
    static __Set = function(_value)
    {
        __valueReset = false;
        
        __valueInput  = _value;
        __valueTarget = _value;
        __valueRate   = infinity;
        
        __OutputRefresh();
    }
    
    static __TargetValueSet = function(_targetValue, _rate)
    {
        __valueReset = false;
        
        __valueTarget = _targetValue;
        __valueRate   = _rate;
    }
    
    static __TargetValueGet = function()
    {
        return __valueTarget;
    }
    
    static __InputGet = function()
    {
        return __valueInput;
    }
    
    static __OutputGet = function()
    {
        return __valueOutput;
    }
    
    static __Reset = function()
    {
        __valueReset = true;
        __OutputRefresh();
    }
    
    static __OutputRefresh = function()
    {
        var _oldOutput = __valueOutput;
        
        if (__valueReset)
        {
            __valueOutput = __valueDefault;
            
            //Remap default value to input
            __valueParam  = clamp((__valueOutput - __outputRange[0]) / (__outputRange[1] - __outputRange[0]), 0, 1);
            __valueInput  = __unlimited? __valueOutput : lerp(__inputRange[0], __inputRange[1], __valueParam);
            __valueTarget = __valueInput;
            __valueRate   = infinity;
        }
        else
        {
            __valueParam = clamp((__valueInput - __inputRange[0]) / (__inputRange[1] - __inputRange[0]), 0, 1);
            
            if (__unlimited)
            {
                __valueOutput = __valueInput;
            }
            else
            {
                //Remap input value to output
                __valueOutput = lerp(__outputRange[0], __outputRange[1], __valueParam);
            }
        }
        
        if (_oldOutput != __valueOutput) __UpdateTargets();
    }
    
    static __UpdateTargets = function()
    {
        var _i = 0;
        repeat(array_length(__targetArray))
        {
            var _target = __targetArray[_i];
            _target.__Update(__valueOutput, __valueParam);
            ++_i;
        }
    }
    
    static __Tick = function(_deltaTimeFactor)
    {
        if (!__valueReset)
        {
            if (__valueInput != __valueTarget)
            {
                __valueInput += clamp(__valueTarget - __valueInput, -_deltaTimeFactor*__valueRate, _deltaTimeFactor*__valueRate);
                __OutputRefresh();
            }
        }
    }
    
    static __BuildPropertyUI = function(_selectionHandler)
    {
        //Now do the actual table
        if (ImGui.BeginTable("Vinyl Properties", 2, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 280))
        {
            //Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("Name",   ImGuiTableColumnFlags.WidthFixed, 100);
            ImGui.TableSetupColumn("Value",  ImGuiTableColumnFlags.WidthStretch, 1);
            
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Unlimited");
            ImGui.TableSetColumnIndex(1);
            __VinylDocument().__Write(self, "__unlimited", ImGui.Checkbox("##Unlimited", __unlimited));
            
            ImGui.BeginDisabled(__unlimited);
                
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(0);
                ImGui.Text("Input Range");
                ImGui.TableSetColumnIndex(1);
                
                var _array = variable_clone(__inputRange);
                ImGui.SetNextItemWidth(ImGui.GetColumnWidth(1));
                ImGui.InputFloat2("##Input Range", _array);
                if (ImGui.IsItemDeactivatedAfterEdit())
                {
                    if (_array[0] > _array[1])
                    {
                        var _temp = _array[1];
                        _array[1] = _array[0];
                        _array[0] = _temp;
                    }
                    
                    __VinylDocument().__Write(self, "__inputRange", _array);
                }
                
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(0);
                ImGui.Text("Output Range");
                ImGui.TableSetColumnIndex(1);
                
                var _array = variable_clone(__outputRange);
                ImGui.SetNextItemWidth(ImGui.GetColumnWidth(1));
                ImGui.InputFloat2("##Output Range", _array);
                if (ImGui.IsItemDeactivatedAfterEdit())
                {
                    if (_array[0] > _array[1])
                    {
                        var _temp = _array[1];
                        _array[1] = _array[0];
                        _array[0] = _temp;
                    }
                    
                    __VinylDocument().__Write(self, "__outputRange", _array);
                    __VinylDocument().__Write(self, "__defaultValue", clamp(__defaultValue, __outputRange[0], __outputRange[1]));
                }
                
            ImGui.EndDisabled();
            
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Default Value");
            ImGui.TableSetColumnIndex(1);
            
            ImGui.SetNextItemWidth(ImGui.GetColumnWidth(1));
            var _newValue = ImGui.InputFloat("##Default Value", __defaultValue);
            if (ImGui.IsItemDeactivatedAfterEdit())
            {
                __VinylDocument().__Write(self, "__defaultValue", clamp(_newValue, __outputRange[0], __outputRange[1]));
            }
            
            ImGui.EndTable();
        }
    }
}
