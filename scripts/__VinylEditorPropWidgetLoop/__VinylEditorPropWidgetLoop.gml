// Feather disable all

/// @param UiID
/// @param dataStruct
/// @param parentStruct
/// @param columnName
/// @param columnValue
/// @param columnOption

function __VinylEditorPropWidgetLoop(_id, _dataStruct, _parentStruct, _columnName, _columnValue, _columnOption)
{
    static _optionArray = [__VINYL_OPTION_UNSET, __VINYL_OPTION_SET];
    
    var _originalOption = (_dataStruct == undefined)? __VINYL_OPTION_UNSET : _dataStruct.__loopOption;
    var _inheriting = (_originalOption == __VINYL_OPTION_UNSET);
    
    var _resolution = __VinylPatternResolveInheritedLoop(_dataStruct, _parentStruct);
    var _loopOption = _resolution.__option;
    var _loop       = _resolution.__value;
    
    ImGui.TableNextRow();
    ImGui.TableSetColumnIndex(_columnName);
    ImGui.Text("Loop");
    
    ImGui.TableSetColumnIndex(_columnValue);
    ImGui.BeginDisabled(_inheriting);
        switch(_loopOption)
        {
            case __VINYL_OPTION_SET:
                var _newValue = ImGui.Checkbox("##Loop " + _id, _loop);
                
                if (not _inheriting)
                {
                    __VinylDocument().__Write(_dataStruct, "__loop", _newValue);
                }
            break;
        }
    ImGui.EndDisabled();
    
    ImGui.TableSetColumnIndex(_columnOption);
    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(_columnOption));
    if (ImGui.BeginCombo("##Loop Option " + _id, _originalOption, ImGuiComboFlags.None))
    {
        var _i = 0;
        repeat(array_length(_optionArray))
        {
            var _optionName = _optionArray[_i];
            if (ImGui.Selectable(_optionName + "##Loop Option " + _id, (_originalOption == _optionName)))
            {
                __VinylDocument().__Write(_dataStruct, "__loopOption", _optionName);
            }
                        
            ++_i;
        }
        
        ImGui.EndCombo();
    }
}