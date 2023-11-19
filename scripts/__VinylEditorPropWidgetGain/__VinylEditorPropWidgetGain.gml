// Feather disable all

/// @param UiID
/// @param dataStruct
/// @param parentStruct
/// @param columnName
/// @param columnValue
/// @param columnOption

function __VinylEditorPropWidgetGain(_id, _dataStruct, _parentStruct, _columnName, _columnValue, _columnOption)
{
    static _optionArray = [__VINYL_OPTION_UNSET, __VINYL_OPTION_MULTIPLY, __VINYL_OPTION_RANDOMIZE, __VINYL_OPTION_KNOB];
    
    //TODO - Optimise this
    var _knobArray = variable_struct_get_names(__VinylDocument().__knobDict);
    array_sort(_knobArray, true);
    
    var _originalOption = (_dataStruct == undefined)? __VINYL_OPTION_UNSET : _dataStruct.__gainOption;
    var _inheriting = (_originalOption == __VINYL_OPTION_UNSET);
    
    var _resolution = __VinylPatternResolveInheritedGain(_dataStruct, _parentStruct);
    var _option       = _resolution.__option;
    var _knob         = _resolution.__knob;
    var _knobOverride = _resolution.__knobOverride;
    var _value        = _resolution.__value;
    
    ImGui.TableNextRow();
    ImGui.TableSetColumnIndex(_columnName);
    ImGui.Text("Gain");
    
    ImGui.TableSetColumnIndex(_columnValue);
    ImGui.BeginDisabled(_inheriting);
        switch(_option)
        {
            case __VINYL_OPTION_MULTIPLY:
                ImGui.SetNextItemWidth(ImGui.GetColumnWidth(_columnValue));
                var _newValue = ImGui.SliderFloat("##Gain " + _id, _value[0], 0, 2);
                
                if (not _inheriting)
                {
                    __VinylDocument().__Write(_dataStruct, "__gain", [_newValue, _newValue]);
                }
            break;
            
            case __VINYL_OPTION_RANDOMIZE:
                var _newValue = variable_clone(_value);
                ImGui.SetNextItemWidth(ImGui.GetColumnWidth(_columnValue));
                ImGui.SliderFloat2("##Gain " + _id, _newValue, 0, 2);
                
                if (not _inheriting)
                {
                    //If the two values have inverted then swap 'em over
                    if (_newValue[0] > _newValue[1])
                    {
                        var _temp = _newValue[0];
                        _newValue[0] = _newValue[1];
                        _newValue[1] = _temp;
                    }
                    
                    __VinylDocument().__Write(_dataStruct, "__gain", _newValue);
                }
            break;
            
            case __VINYL_OPTION_KNOB:
                ImGui.SetNextItemWidth(ImGui.GetColumnWidth(_columnValue));
                if (ImGui.BeginCombo("##Gain Knob Combo " + _id, _knob, ImGuiComboFlags.None))
                {
                    var _i = 0;
                    repeat(array_length(_knobArray))
                    {
                        var _knobName = _knobArray[_i];
                        if (ImGui.Selectable(_knobName + "##Gain Option " + _id, (_knob == _knobName)))
                        {
                            if (not _inheriting)
                            {
                                __VinylDocument().__Write(_dataStruct, "__gainKnob", _knobName);
                            }
                        }
                        
                        ++_i;
                    }
                    
                    ImGui.EndCombo();
                }
                
                ImGui.BeginDisabled(not _knobOverride || _inheriting);
                    var _newValue = variable_clone(_value);
                    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(_columnValue));
                    ImGui.SliderFloat2("##Gain " + _id, _newValue, 0, 2);
                    
                    if ((not _inheriting) && (not array_equals(_value, _newValue)))
                    {
                        //If the two values have inverted then swap 'em over
                        if (_newValue[0] > _newValue[1])
                        {
                            var _temp = _newValue[0];
                            _newValue[0] = _newValue[1];
                            _newValue[1] = _temp;
                        }
                        
                        __VinylDocument().__Write(_dataStruct, "__gain", _newValue);
                    }
                ImGui.EndDisabled();
            break;
        }
    ImGui.EndDisabled();
    
    ImGui.TableSetColumnIndex(_columnOption);
    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(_columnOption));
    if (ImGui.BeginCombo("##Gain Option " + _id, _originalOption, ImGuiComboFlags.None))
    {
        var _i = 0;
        repeat(array_length(_optionArray))
        {
            var _optionName = _optionArray[_i];
            if (ImGui.Selectable(_optionName + "##Gain Option " + _id, (_originalOption == _optionName)))
            {
                __VinylDocument().__Write(_dataStruct, "__gainOption", _optionName);
                
                //Set the min/max values to be identical when setting non-randomized mode
                if (_optionName == __VINYL_OPTION_MULTIPLY)
                {
                    __VinylDocument().__Write(_dataStruct, "__gain", [_value[0], _value[0]]);
                }
            }
                        
            ++_i;
        }
        
        ImGui.EndCombo();
    }
    
    if (_option == __VINYL_OPTION_KNOB)
    {
        ImGui.BeginDisabled(_inheriting);
            ImGui.TableSetColumnIndex(_columnOption);
            var _newOverride = ImGui.Checkbox("Override Range##Gain Override Checkbox " + _id, _knobOverride);
            
            if (not _inheriting)
            {
                __VinylDocument().__Write(_dataStruct, "__gainKnobOverride", _newOverride);
            }
        ImGui.EndDisabled();
    }
}