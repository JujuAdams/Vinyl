// Feather disable all

/// @param UiID
/// @param dataStruct
/// @param parentStruct
/// @param columnName
/// @param columnValue
/// @param columnOption

function __VinylEditorPropWidgetPersistent(_id, _dataStruct, _parentStruct, _columnName, _columnValue, _columnOption)
{
    static _optionArray = [__VINYL_OPTION_UNSET, __VINYL_OPTION_SET];
    
    var _originalOption = (_dataStruct == undefined)? __VINYL_OPTION_UNSET : _dataStruct.__persistentOption;
    var _inheriting = (_originalOption == __VINYL_OPTION_UNSET);
    
    var _resolution = __VinylPatternResolveInheritedPersistent(_dataStruct, _parentStruct);
    var _option = _resolution.__option;
    var _value  = _resolution.__value;
    
    ImGui.TableNextRow();
    ImGui.TableSetColumnIndex(_columnName);
    ImGui.Text("Persistent");
    
    ImGui.TableSetColumnIndex(_columnValue);
    ImGui.BeginDisabled(_inheriting);
        switch(_option)
        {
            case __VINYL_OPTION_SET:
                var _newValue = ImGui.Checkbox("##Persistent " + _id, _value);
                
                if (not _inheriting)
                {
                    _dataStruct.__persistent = _newValue;
                }
            break;
        }
    ImGui.EndDisabled();
    
    ImGui.TableSetColumnIndex(_columnOption);
    if (_inheriting && is_struct(_parentStruct))
    {
        ImGui.Text(_option);
    }
    else
    {
        if (ImGui.BeginCombo("##Persistent Option " + _id, _originalOption, ImGuiComboFlags.None))
        {
            var _i = 0;
            repeat(array_length(_optionArray))
            {
                var _optionName = _optionArray[_i];
                if (ImGui.Selectable(_optionName + "##Persistent Option " + _id, (_originalOption == _optionName)))
                {
                    _dataStruct.__persistentOption = _optionName;
                }
                        
                ++_i;
            }
            
            ImGui.EndCombo();
        }
    }
}