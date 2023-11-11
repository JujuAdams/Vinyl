// Feather disable all

function __VinylEditorPropWidgetEffectChain(_id, _dataStruct, _parentStruct)
{
    static _optionArray = ["Unset", "Override"];
    static _columnTree   = 0;
    static _columnDelete = 1;
    static _columnValue  = 2;
    static _columnOption = 3;
    
    var _effectChainArray = ["Reverb"];
    
    var _originalOption = _dataStruct.effectChainOption;
    var _inheriting = (_originalOption == "Unset");
    
    var _resolution = __VinylPatternResolveInheritedEffectChain(_dataStruct, _parentStruct);
    var _option   = _resolution.__option;
    var _value    = _resolution.__value;
    
    ImGui.TableNextRow();
    ImGui.TableSetColumnIndex(_columnTree);
    ImGui.Text("Effect Chain");
    
    ImGui.TableSetColumnIndex(_columnValue);
    ImGui.BeginDisabled(_inheriting);
        switch(_option)
        {
            case "Override":
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
                                _dataStruct.effectChain = _effectChainName;
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
    if (ImGui.BeginCombo("##Effect Chain Option " + _id, _originalOption, ImGuiComboFlags.None))
    {
        var _i = 0;
        repeat(array_length(_optionArray))
        {
            var _optionName = _optionArray[_i];
            if (ImGui.Selectable(_optionName + "##Effect Chain Option " + _id, (_originalOption == _optionName)))
            {
                _dataStruct.effectChainOption = _optionName;
            }
                        
            ++_i;
        }
        
        ImGui.EndCombo();
    }
}