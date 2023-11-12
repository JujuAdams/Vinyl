// Feather disable all

/// @param UiID
/// @param dataStruct
/// @param parentStruct
/// @param columnName
/// @param columnValue
/// @param columnOption

function __VinylEditorPropWidgetGain(_id, _dataStruct, _parentStruct, _columnName, _columnValue, _columnOption)
{
    static _optionArray = ["Unset", "Multiply", "Randomize", "Knob"];
    
    //TODO
    var _knobArray = ["spookiness", "health factor"];
    
    var _originalOption = (_dataStruct == undefined)? "Unset" : _dataStruct.gainOption;
    var _inheriting = (_originalOption == "Unset");
    
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
            case "Multiply":
                var _newValue = ImGui.SliderFloat("##Gain " + _id, _value[0], 0, 2);
                
                if (not _inheriting)
                {
                    _value[0] = _newValue;
                    _value[1] = _newValue;
                }
            break;
            
            case "Randomize":
                var _newValue = variable_clone(_value);
                ImGui.SliderFloat2("##Gain " + _id, _newValue, 0, 2);
                
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
            break;
            
            case "Knob":
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
                                _dataStruct.gainKnob = _knobName;
                            }
                        }
                        
                        ++_i;
                    }
                    
                    ImGui.EndCombo();
                }
                
                ImGui.BeginDisabled(not _knobOverride || _inheriting);
                    var _newValue = variable_clone(_value);
                    ImGui.SliderFloat2("##Gain " + _id, _newValue, 0, 2);
                    
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
    if (ImGui.BeginCombo("##Gain Option " + _id, _originalOption, ImGuiComboFlags.None))
    {
        var _i = 0;
        repeat(array_length(_optionArray))
        {
            var _optionName = _optionArray[_i];
            if (ImGui.Selectable(_optionName + "##Gain Option " + _id, (_originalOption == _optionName)))
            {
                _dataStruct.gainOption = _optionName;
                
                //Set the min/max values to be identical when setting non-randomized mode
                if (_optionName == "Multiply")
                {
                    _value[1] = _value[0];
                }
            }
                        
            ++_i;
        }
        
        ImGui.EndCombo();
    }
    
    if (_option == "Knob")
    {
        ImGui.BeginDisabled(_inheriting);
            ImGui.TableSetColumnIndex(_columnOption);
            var _newOverride = ImGui.Checkbox("Override Range##" + _id, _knobOverride);
            
            if (not _inheriting)
            {
                _dataStruct.gainKnobOverride = _newOverride;
            }
        ImGui.EndDisabled();
    }
}