// Feather disable all

/// @param UiID
/// @param dataStruct
/// @param parentStruct
/// @param columnName
/// @param columnValue
/// @param columnOption

function __VinylEditorPropWidgetTranspose(_id, _dataStruct, _parentStruct, _columnName, _columnValue, _columnOption)
{
    static _optionArray = [__VINYL_OPTION_UNSET, __VINYL_OPTION_SET, __VINYL_OPTION_KNOB];
    
    //TODO - Optimise this
    var _knobDict = __VinylDocument().__knobDict;
    var _knobArray = variable_struct_get_names(_knobDict);
    array_sort(_knobArray, true);
    
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
            case __VINYL_OPTION_SET:
                ImGui.SetNextItemWidth(ImGui.GetColumnWidth(_columnValue));
                var _newValue = ImGui.SliderInt("##Transpose " + _id, _value[0], -24, 24);
                
                if (not _inheriting)
                {
                    __VinylDocument().__Write(_dataStruct, "__transpose", [_newValue, _newValue]);
                }
            break;
            
            case __VINYL_OPTION_KNOB:
                ImGui.SetNextItemWidth(ImGui.GetColumnWidth(_columnValue));
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
                                __VinylDocument().__Write(_dataStruct, "__transposeKnob", _knobName);
                            }
                        }
                        
                        ++_i;
                    }
                    
                    ImGui.EndCombo();
                }
                
                if (not _knobOverride || _inheriting)
                {
                    var _knobData = _knobDict[$ _knob];
                    
                    ImGui.BeginDisabled(true);
                        ImGui.SetNextItemWidth(ImGui.GetColumnWidth(_columnValue));
                        
                        if (is_struct(_knobData))
                        {
                            ImGui.InputInt2("##Transpose " + _id, _knobData.__outputRange);
                        }
                        else
                        {
                            ImGui.InputInt2("##Transpose " + _id, [0, 1]);
                        }
                        
                    ImGui.EndDisabled();
                }
                else
                {
                    var _newValue = variable_clone(_value);
                    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(_columnValue));
                    ImGui.SliderInt2("##Transpose " + _id, _newValue, -24, 24);
                    
                    if ((not _inheriting) && (not array_equals(_value, _newValue)))
                    {
                        //If the two values have inverted then swap 'em over
                        if (_newValue[0] > _newValue[1])
                        {
                            var _temp = _newValue[0];
                            _newValue[0] = _newValue[1];
                            _newValue[1] = _temp;
                        }
                        
                        __VinylDocument().__Write(_dataStruct, "__transpose", _newValue);
                    }
                }
            break;
        }
    ImGui.EndDisabled();
    
    ImGui.TableSetColumnIndex(_columnOption);
    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(_columnOption));
    if (ImGui.BeginCombo("##Transpose Option " + _id, _originalOption, ImGuiComboFlags.None))
    {
        var _i = 0;
        repeat(array_length(_optionArray))
        {
            var _optionName = _optionArray[_i];
            if (ImGui.Selectable(_optionName + "##Transpose Option " + _id, (_originalOption == _optionName)))
            {
                __VinylDocument().__Write(_dataStruct, "__transposeOption", _optionName);
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
            var _newOverride = ImGui.Checkbox("Override Range##Transpose Override Checkbox " + _id, _knobOverride);
            
            if (not _inheriting)
            {
                __VinylDocument().__Write(_dataStruct, "__transposeKnobOverride", _newOverride);
            }
        ImGui.EndDisabled();
    }
}