// Feather disable all

function __VinylEditorPropWidgetStack(_id, _dataStruct, _parentStruct)
{
    static _optionArray = ["Unset", "Override"];
    static _columnTree   = 0;
    static _columnDelete = 1;
    static _columnValue  = 2;
    static _columnOption = 3;
    
    var _stackArray = ["Music"];
    
    var _originalOption = _dataStruct.stackOption;
    var _inheriting = (_originalOption == "Unset");
    
    var _resolution = __VinylPatternResolveInheritedStack(_dataStruct, _parentStruct);
    var _option   = _resolution.__option;
    var _value    = _resolution.__value;
    var _priority = _resolution.__priority;
    
    ImGui.TableNextRow();
    ImGui.TableSetColumnIndex(_columnTree);
    ImGui.Text("Stack");
    
    ImGui.TableSetColumnIndex(_columnValue);
    ImGui.BeginDisabled(_inheriting);
        switch(_option)
        {
            case "Override":
                if (ImGui.BeginCombo("##Stack " + _id, _value, ImGuiComboFlags.None))
                {
                    var _i = 0;
                    repeat(array_length(_stackArray))
                    {
                        var _stackName = _stackArray[_i];
                        if (ImGui.Selectable(_stackName + "##Stack Option " + _id, (_value == _stackName)))
                        {
                            if (not _inheriting)
                            {
                                _dataStruct.stack = _stackName;
                            }
                        }
                        
                        ++_i;
                    }
                    
                    ImGui.EndCombo();
                }
            break;
        }
    ImGui.EndDisabled();
    
    ImGui.TableSetColumnIndex(_columnOption);
    if (ImGui.BeginCombo("##Stack Option " + _id, _originalOption, ImGuiComboFlags.None))
    {
        var _i = 0;
        repeat(array_length(_optionArray))
        {
            var _optionName = _optionArray[_i];
            if (ImGui.Selectable(_optionName + "##Stack Option " + _id, (_originalOption == _optionName)))
            {
                _dataStruct.stackOption = _optionName;
            }
                        
            ++_i;
        }
        
        ImGui.EndCombo();
    }
    
    if (_option == "Override")
    {
        ImGui.TableNextRow();
        ImGui.TableSetColumnIndex(_columnTree);
        ImGui.Text("Stack Priority");
        
        ImGui.TableSetColumnIndex(_columnValue);
        var _newValue = ImGui.InputInt("##Stack Priority " + _id, _priority);
        if (not _inheriting)
        {
            _dataStruct.__stackPriority = _newValue;
        }
    }
}