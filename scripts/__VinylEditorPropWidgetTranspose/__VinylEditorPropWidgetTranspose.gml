// Feather disable all

/// @param UiID
/// @param dataStruct
/// @param parentStruct
/// @param columnName
/// @param columnValue
/// @param columnOption

function __VinylEditorPropWidgetTranspose(_id, _dataStruct, _parentStruct, _columnName, _columnValue, _columnOption)
{
    static _optionArray = [__VINYL_OPTION_UNSET, __VINYL_OPTION_OVERRIDE, __VINYL_OPTION_KNOB];
    
    //TODO
    var _knobArray = ["spookiness", "health factor"];
    
    var _originalOption = (_dataStruct == undefined)? __VINYL_OPTION_UNSET : _dataStruct.__transposeOption;
    var _inheriting = (_originalOption == __VINYL_OPTION_UNSET);
    
    var _resolution = __VinylPatternResolveInheritedTranspose(_dataStruct, _parentStruct);
    var _option       = _resolution.__option;
    var _knob         = _resolution.__knob;
    var _knobOverride = _resolution.__knobOverride;
    var _value        = _resolution.__value;
    
    ImGui.TableNextRow();
    ImGui.TableSetColumnIndex(_columnName);
    ImGui.Text("Transpose");
    
    ImGui.TableSetColumnIndex(_columnValue);
    ImGui.BeginDisabled(_inheriting);
        switch(_option)
        {
            case __VINYL_OPTION_OVERRIDE:
                var _newValue = ImGui.SliderInt("##Transpose " + _id, _value[0], -24, 24);
                
                if (not _inheriting)
                {
                    _value[0] = _newValue;
                    _value[1] = _newValue;
                }
            break;
            
            case __VINYL_OPTION_KNOB:
                if (ImGui.BeginCombo("##Transpose Knob Combo " + _id, _knob, ImGuiComboFlags.None))
                {
                    var _i = 0;
                    repeat(array_length(_knobArray))
                    {
                        var _knobName = _knobArray[_i];
                        if (ImGui.Selectable(_knobName + "##Transpose Option " + _id, (_knob == _knobName)))
                        {
                            if (not _inheriting)
                            {
                                _dataStruct.__transposeKnob = _knobName;
                            }
                        }
                        
                        ++_i;
                    }
                    
                    ImGui.EndCombo();
                }
                
                ImGui.BeginDisabled(not _knobOverride || _inheriting);
                    var _newValue = variable_clone(_value);
                    ImGui.SliderInt2("##Transpose " + _id, _newValue, -24, 24);
                    
                    if ((not _inheriting) && (not array_equals(_value, _newValue)))
                    {
                        if (_newValue[0] < _newValue[1])
                        {
                            _value[0] = _newValue[0];
                            _value[1] = _newValue[1];
                        }
                        else
                        {
                            //If the two values have inverted, correct that
                            _value[0] = _newValue[1];
                            _value[1] = _newValue[0];
                        }
                    }
                ImGui.EndDisabled();
            break;
        }
    ImGui.EndDisabled();
    
    ImGui.TableSetColumnIndex(_columnOption);
    if (ImGui.BeginCombo("##Transpose Option " + _id, _originalOption, ImGuiComboFlags.None))
    {
        var _i = 0;
        repeat(array_length(_optionArray))
        {
            var _optionName = _optionArray[_i];
            if (ImGui.Selectable(_optionName + "##Transpose Option " + _id, (_originalOption == _optionName)))
            {
                _dataStruct.__transposeOption = _optionName;
            }
                        
            ++_i;
        }
        
        ImGui.EndCombo();
    }
    
    if (_option == __VINYL_OPTION_KNOB)
    {
        //TODO - Collect knob output range
        ImGui.BeginDisabled(_inheriting);
            ImGui.TableSetColumnIndex(_columnOption);
            var _newOverride = ImGui.Checkbox("Override Range##" + _id, _knobOverride);
            
            if (not _inheriting)
            {
                _dataStruct.__transposeKnobOverride = _newOverride;
            }
        ImGui.EndDisabled();
    }
}