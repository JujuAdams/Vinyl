// Feather disable all

/// @param UiID
/// @param dataStruct
/// @param parentStruct
/// @param columnName
/// @param columnValue
/// @param columnOption

function __VinylEditorPropWidgetLoop(_id, _dataStruct, _parentStruct, _columnName, _columnValue, _columnOption)
{
    static _optionArray = ["Unset", "Override"];
    
    var _originalOption = (_dataStruct == undefined)? "Unset" : _dataStruct.loopOption;
    var _inheriting = (_originalOption == "Unset");
    
    var _resolution = __VinylPatternResolveInheritedLoop(_dataStruct, _parentStruct);
    var _option = _resolution.__option;
    var _value  = _resolution.__value;
    
    ImGui.TableNextRow();
    ImGui.TableSetColumnIndex(_columnName);
    ImGui.Text("Loop");
    
    ImGui.TableSetColumnIndex(_columnValue);
    ImGui.BeginDisabled(_inheriting);
        switch(_option)
        {
            case "Override":
                var _newValue = ImGui.Checkbox("##Loop " + _id, _value);
                
                if (not _inheriting)
                {
                    _dataStruct.loop = _newValue;
                }
            break;
        }
    ImGui.EndDisabled();
    
    ImGui.TableSetColumnIndex(_columnOption);
    if (ImGui.BeginCombo("##Loop Option " + _id, _originalOption, ImGuiComboFlags.None))
    {
        var _i = 0;
        repeat(array_length(_optionArray))
        {
            var _optionName = _optionArray[_i];
            if (ImGui.Selectable(_optionName + "##Loop Option " + _id, (_originalOption == _optionName)))
            {
                _dataStruct.loopOption = _optionName;
            }
                        
            ++_i;
        }
        
        ImGui.EndCombo();
    }
}