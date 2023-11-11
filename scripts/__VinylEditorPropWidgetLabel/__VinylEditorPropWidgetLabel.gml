// Feather disable all

function __VinylEditorPropWidgetLabel(_id, _dataStruct, _parentStruct)
{
    static _optionArray = ["Unset", "Add", "Override"];
    static _columnTree   = 0;
    static _columnDelete = 1;
    static _columnValue  = 2;
    static _columnOption = 3;
    
    //TODO
    var _labelArray = ["A", "B", "C"];
    
    var _option        = _dataStruct.labelsOption;
    var _originalArray = _dataStruct.labels;
    
    var _inheritedArray = [];
    __VinylPatternResolveInheritedLabel(_dataStruct, _parentStruct, _inheritedArray);
    array_sort(_inheritedArray, true);
    
    ImGui.TableNextRow();
    ImGui.TableSetColumnIndex(_columnTree);
    ImGui.Text("Label");
    
    ImGui.TableSetColumnIndex(_columnValue);
    var _string = __VinylLabelsGetAbbreviatedName(_inheritedArray);
    switch(_option)
    {
        case "Unset":
            ImGui.Text(_string);
        break;
        
        case "Add":
        case "Override":
            if (ImGui.BeginCombo("##Label Option " + _id, _string, ImGuiComboFlags.None))
            {
                var _i = 0;
                repeat(array_length(_labelArray))
                {
                    var _labelName = _labelArray[_i];
                    
                    var _oldValue = array_contains(_originalArray, _labelName);
                    var _inheritedValue = array_contains(_inheritedArray, _labelName);
                    
                    var _displayName = _labelName;
                    if (_inheritedValue) _displayName += " *";
                    var _newValue = ImGui.Checkbox(_displayName + "##Label Option " + _labelName + " " + _id, _oldValue);
                    
                    if (_oldValue != _newValue)
                    {
                        if (_newValue)
                        {
                            array_push(_originalArray, _labelName);
                        }
                        else
                        {
                            array_delete(_originalArray, __VinylArrayFindIndex(_originalArray, _labelName), 1);
                        }
                    }
                    
                    ++_i;
                }
                
                ImGui.EndCombo();
            }
        break;
    }
    
    ImGui.TableSetColumnIndex(_columnOption);
    if (ImGui.BeginCombo("##Label Option Combo " + _id, _option, ImGuiComboFlags.None))
    {
        var _i = 0;
        repeat(array_length(_optionArray))
        {
            var _optionName = _optionArray[_i];
            if (ImGui.Selectable(_optionName + "##Label Option " + _id, (_option == _optionName)))
            {
                _dataStruct.labelsOption = _optionName;
            }
            
            ++_i;
        }
        
        ImGui.EndCombo();
    }
}