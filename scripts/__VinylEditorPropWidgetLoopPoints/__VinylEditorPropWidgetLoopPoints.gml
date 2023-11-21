// Feather disable all

/// @param UiID
/// @param dataStruct
/// @param parentStruct
/// @param columnName
/// @param columnValue
/// @param columnOption

function __VinylEditorPropWidgetLoopPoints(_id, _dataStruct, _parentStruct, _columnName, _columnValue, _columnOption)
{
    static _optionArray = [__VINYL_OPTION_UNSET, __VINYL_OPTION_SET];
    
    var _originalOption = (_dataStruct == undefined)? __VINYL_OPTION_UNSET : _dataStruct.__loopPointsOption;
    var _inheriting = (_originalOption == __VINYL_OPTION_UNSET);
    
    var _resolution = __VinylPatternResolveInheritedLoopPoints(_dataStruct, _parentStruct);
    var _loopPointsOption = _resolution.__option;
    var _loopPoints       = _resolution.__value;
    
    ImGui.TableNextRow();
    ImGui.TableSetColumnIndex(_columnName);
    ImGui.Text("Loop Points");
    
    ImGui.TableSetColumnIndex(_columnValue);
    ImGui.BeginDisabled(_inheriting);
        switch(_loopPointsOption)
        {
            case __VINYL_OPTION_SET:
                var _newValue = variable_clone(_loopPoints);
                ImGui.InputFloat2("seconds##Loop Points " + _id, _newValue, 0, 2);
                
                if (not _inheriting)
                {
                    //If the two values have inverted then swap 'em over
                    if (_newValue[0] > _newValue[1])
                    {
                        var _temp = _newValue[0];
                        _newValue[0] = _newValue[1];
                        _newValue[1] = _temp;
                    }
                    
                    __VinylDocument().__Write(_dataStruct, "__loopPoints", _newValue);
                }
            break;
        }
    ImGui.EndDisabled();
    
    ImGui.TableSetColumnIndex(_columnOption);
    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(_columnOption));
    if (ImGui.BeginCombo("##Loop Points Option " + _id, _originalOption, ImGuiComboFlags.None))
    {
        var _i = 0;
        repeat(array_length(_optionArray))
        {
            var _optionName = _optionArray[_i];
            if (ImGui.Selectable(_optionName + "##Loop Points Option " + _id, (_originalOption == _optionName)))
            {
                __VinylDocument().__Write(_dataStruct, "__loopPointsOption", _optionName);
            }
            
            ++_i;
        }
        
        ImGui.EndCombo();
    }
}