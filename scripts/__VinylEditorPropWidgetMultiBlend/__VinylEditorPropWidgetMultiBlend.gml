// Feather disable all

/// @param UiID
/// @param dataStruct
/// @param parentStruct
/// @param columnName
/// @param columnValue
/// @param columnOption

function __VinylEditorPropWidgetMultiBlend(_id, _dataStruct, _parentStruct, _columnName, _columnValue, _columnOption)
{
    static _optionArray = [__VINYL_OPTION_SET, __VINYL_OPTION_KNOB];
    
    //TODO - Optimise this
    var _knobDict = __VinylDocument().__knobDict;
    var _knobArray = variable_struct_get_names(_knobDict);
    array_sort(_knobArray, true);
    
    var _option       = _dataStruct.__blendOption;
    var _knob         = _dataStruct.__blendKnob;
    var _knobOverride = _dataStruct.__blendKnobOverride;
    var _value        = _dataStruct.__blend;
    
    ImGui.TableNextRow();
    ImGui.TableSetColumnIndex(_columnName);
    ImGui.Text("Blend");
    
    ImGui.TableSetColumnIndex(_columnValue);
    switch(_option)
    {
        case __VINYL_OPTION_SET:
            ImGui.SetNextItemWidth(ImGui.GetColumnWidth(_columnValue));
            var _newValue = ImGui.SliderFloat("##Blend " + _id, _value[0], 0, 1);
            __VinylDocument().__Write(_dataStruct, "__blend", [_newValue, _newValue]);
        break;
        
        case __VINYL_OPTION_KNOB:
            ImGui.SetNextItemWidth(ImGui.GetColumnWidth(_columnValue));
            if (ImGui.BeginCombo("##Blend Knob Combo " + _id, _knob, ImGuiComboFlags.None))
            {
                var _i = 0;
                repeat(array_length(_knobArray))
                {
                    var _knobName = _knobArray[_i];
                    if (ImGui.Selectable(_knobName + "##Blend Option " + _id, (_knob == _knobName)))
                    {
                        __VinylDocument().__Write(_dataStruct, "__blendKnob", _knobName);
                    }
                        
                    ++_i;
                }
                    
                ImGui.EndCombo();
            }
                
            if (not _knobOverride)
            {
                var _knobData = _knobDict[$ _knob];
                    
                ImGui.BeginDisabled(true);
                    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(_columnValue));
                        
                    if (is_struct(_knobData))
                    {
                        ImGui.InputFloat2("##Blend " + _id, _knobData.__outputRange);
                    }
                    else
                    {
                        ImGui.InputFloat2("##Blend " + _id, [0, 1]);
                    }
                        
                ImGui.EndDisabled();
            }
            else
            {
                var _newValue = variable_clone(_value);
                ImGui.SetNextItemWidth(ImGui.GetColumnWidth(_columnValue));
                ImGui.SliderFloat2("##Blend " + _id, _newValue, 0, 1);
                    
                if (not array_equals(_value, _newValue))
                {
                    //If the two values have inverted then swap 'em over
                    if (_newValue[0] > _newValue[1])
                    {
                        var _temp = _newValue[0];
                        _newValue[0] = _newValue[1];
                        _newValue[1] = _temp;
                    }
                        
                    __VinylDocument().__Write(_dataStruct, "__blend", _newValue);
                }
            }
        break;
    }
    
    ImGui.TableSetColumnIndex(_columnOption);
    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(_columnOption));
    if (ImGui.BeginCombo("##Blend Combo " + _id, _option, ImGuiComboFlags.None))
    {
        var _i = 0;
        repeat(array_length(_optionArray))
        {
            var _optionName = _optionArray[_i];
            if (ImGui.Selectable(_optionName + "##Blend Option " + _id, (_option == _optionName)))
            {
                __VinylDocument().__Write(_dataStruct, "__blendOption", _optionName);
                
                //Set the min/max values to be identical when setting non-randomized mode
                if (_optionName == __VINYL_OPTION_MULTIPLY)
                {
                    __VinylDocument().__Write(_dataStruct, "__blend", [_value[0], _value[0]]);
                }
            }
                        
            ++_i;
        }
        
        ImGui.EndCombo();
    }
    
    if (_option == __VINYL_OPTION_KNOB)
    {
        ImGui.TableSetColumnIndex(_columnOption);
        var _newOverride = ImGui.Checkbox("Override Range##Blend Override Checkbox " + _id, _knobOverride);
        __VinylDocument().__Write(_dataStruct, "__blendKnobOverride", _newOverride);
    }
}