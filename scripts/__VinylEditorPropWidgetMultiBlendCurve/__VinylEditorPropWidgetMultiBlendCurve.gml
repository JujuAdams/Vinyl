// Feather disable all

/// @param UiID
/// @param dataStruct
/// @param parentStruct
/// @param columnName
/// @param columnValue
/// @param columnOption

function __VinylEditorPropWidgetMultiBlendCurve(_id, _dataStruct, _parentStruct, _columnName, _columnValue, _columnOption)
{
    static _optionArray = [__VINYL_OPTION_UNSET, __VINYL_OPTION_SET];
    
    var _curveArray = ["acTest", "acOtherTest"];
    
    var _option = _dataStruct.__blendCurveOption;
    var _value  = _dataStruct.__blendCurveName;
    
    ImGui.TableNextRow();
    ImGui.TableSetColumnIndex(_columnName);
    ImGui.Text("Blend Curve");
    
    ImGui.TableSetColumnIndex(_columnValue);
    switch(_option)
    {
        case __VINYL_OPTION_SET:
            ImGui.SetNextItemWidth(ImGui.GetColumnWidth(_columnValue));
            if (ImGui.BeginCombo("##Blend Curve " + _id, _value, ImGuiComboFlags.None))
            {
                var _i = 0;
                repeat(array_length(_curveArray))
                {
                    var _curveName = _curveArray[_i];
                    if (ImGui.Selectable(_curveName + "##Blend Curve Option " + _id, (_value == _curveName)))
                    {
                        __VinylDocument().__Write(_dataStruct, "__blendCurveName", _curveName);
                    }
                    
                    ++_i;
                }
                
                ImGui.EndCombo();
            }
        break;
    }
    
    ImGui.TableSetColumnIndex(_columnOption);
    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(_columnOption));
    if (ImGui.BeginCombo("##Blend Curve Combo " + _id, _option, ImGuiComboFlags.None))
    {
        var _i = 0;
        repeat(array_length(_optionArray))
        {
            var _optionName = _optionArray[_i];
            if (ImGui.Selectable(_optionName + "##Blend Curve Option " + _id, (_option == _optionName)))
            {
                __VinylDocument().__Write(_dataStruct, "__blendCurveOption", _optionName);
            }
                        
            ++_i;
        }
        
        ImGui.EndCombo();
    }
}