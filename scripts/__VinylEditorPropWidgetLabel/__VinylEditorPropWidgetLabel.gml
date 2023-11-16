// Feather disable all

/// @param UiID
/// @param dataStruct
/// @param parentStruct
/// @param columnName
/// @param columnValue
/// @param columnOption

function __VinylEditorPropWidgetLabel(_id, _dataStruct, _parentStruct, _columnName, _columnValue, _columnOption)
{
    static _optionArray = [__VINYL_OPTION_UNSET, __VINYL_OPTION_ADD, __VINYL_OPTION_OVERRIDE];
    
    //TODO
    var _labelArray = ["A", "B", "C"];
    
    var _option        = (_dataStruct == undefined)? __VINYL_OPTION_UNSET : _dataStruct.__labelsOption;
    var _originalArray = (_dataStruct == undefined)? [] : _dataStruct.__labelArray;
    
    var _inheritedArray = [];
    __VinylPatternResolveInheritedLabel(_dataStruct, _parentStruct, _inheritedArray);
    array_sort(_inheritedArray, true);
    
    ImGui.TableNextRow();
    ImGui.TableSetColumnIndex(_columnName);
    ImGui.Text("Label");
    
    ImGui.TableSetColumnIndex(_columnValue);
    var _string = __VinylLabelsGetAbbreviatedName(_inheritedArray);
    switch(_option)
    {
        case __VINYL_OPTION_UNSET:
            ImGui.Text(_string);
        break;
        
        case __VINYL_OPTION_ADD:
        case __VINYL_OPTION_OVERRIDE:
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
                _dataStruct.__labelsOption = _optionName;
            }
            
            ++_i;
        }
        
        ImGui.EndCombo();
    }
}