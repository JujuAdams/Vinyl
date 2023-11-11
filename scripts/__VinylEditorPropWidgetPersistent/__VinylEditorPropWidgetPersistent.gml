// Feather disable all

function __VinylEditorPropWidgetPersistent(_id, _dataStruct, _parentStruct)
{
    static _optionArray = ["Unset", "Override"];
    static _columnTree   = 0;
    static _columnDelete = 1;
    static _columnValue  = 2;
    static _columnOption = 3;
    
    var _originalOption = _dataStruct.persistentOption;
    var _inheriting = (_originalOption == "Unset");
    
    var _resolution = __VinylPatternResolveInheritedPersistent(_dataStruct, _parentStruct);
    var _option = _resolution.__option;
    var _value  = _resolution.__value;
    
    ImGui.TableNextRow();
    ImGui.TableSetColumnIndex(_columnTree);
    ImGui.Text("Persistent");
    
    ImGui.TableSetColumnIndex(_columnValue);
    ImGui.BeginDisabled(_inheriting);
        switch(_option)
        {
            case "Override":
                var _newValue = ImGui.Checkbox("##Persistent " + _id, _value);
                
                if (not _inheriting)
                {
                    _dataStruct.persistent = _newValue;
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
                    _dataStruct.persistentOption = _optionName;
                }
                        
                ++_i;
            }
            
            ImGui.EndCombo();
        }
    }
}