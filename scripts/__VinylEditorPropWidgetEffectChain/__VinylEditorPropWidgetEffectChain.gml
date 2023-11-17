// Feather disable all

/// @param UiID
/// @param dataStruct
/// @param parentStruct
/// @param columnName
/// @param columnValue
/// @param columnOption

function __VinylEditorPropWidgetEffectChain(_id, _dataStruct, _parentStruct, _columnName, _columnValue, _columnOption)
{
    static _optionArray = [__VINYL_OPTION_UNSET, __VINYL_OPTION_SET];
    
    var _effectChainArray = ["Reverb"];
    
    var _originalOption = (_dataStruct == undefined)? __VINYL_OPTION_UNSET : _dataStruct.__effectChainOption;
    var _inheriting = (_originalOption == __VINYL_OPTION_UNSET);
    
    var _resolution = __VinylPatternResolveInheritedEffectChain(_dataStruct, _parentStruct);
    var _option   = _resolution.__option;
    var _value    = _resolution.__value;
    
    ImGui.TableNextRow();
    ImGui.TableSetColumnIndex(_columnName);
    ImGui.Text("Effect Chain");
    
    ImGui.TableSetColumnIndex(_columnValue);
    ImGui.BeginDisabled(_inheriting);
        switch(_option)
        {
            case __VINYL_OPTION_SET:
                ImGui.SetNextItemWidth(ImGui.GetColumnWidth(_columnValue));
                if (ImGui.BeginCombo("##Effect Chain " + _id, _value, ImGuiComboFlags.None))
                {
                    var _i = 0;
                    repeat(array_length(_effectChainArray))
                    {
                        var _effectChainName = _effectChainArray[_i];
                        if (ImGui.Selectable(_effectChainName + "##Effect Chain Option " + _id, (_value == _effectChainName)))
                        {
                            if (not _inheriting)
                            {
                                __VinylDocument().__Write(_dataStruct, "__effectChainName", _effectChainName);
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
    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(_columnOption));
    if (ImGui.BeginCombo("##Effect Chain Option " + _id, _originalOption, ImGuiComboFlags.None))
    {
        var _i = 0;
        repeat(array_length(_optionArray))
        {
            var _optionName = _optionArray[_i];
            if (ImGui.Selectable(_optionName + "##Effect Chain Option " + _id, (_originalOption == _optionName)))
            {
                __VinylDocument().__Write(_dataStruct, "__effectChainOption", _optionName);
            }
                        
            ++_i;
        }
        
        ImGui.EndCombo();
    }
}