// Feather disable all

/// @param UiID
/// @param dataStruct
/// @param parentStruct
/// @param columnName
/// @param columnValue
/// @param columnOption

function __VinylEditorPropWidgetQueueBehavior(_id, _dataStruct, _parentStruct, _columnName, _columnValue, _columnOption)
{
    static _optionArray   = [__VINYL_OPTION_UNSET, __VINYL_OPTION_SET];
    static _behaviorArray = [__VINYL_QUEUE_PLAY_ONCE, __VINYL_QUEUE_REPEAT_ALL, __VINYL_QUEUE_REPEAT_LAST];
    
    var _behavior = _dataStruct.__behavior;
    
    ImGui.TableNextRow();
    ImGui.TableSetColumnIndex(_columnName);
    ImGui.Text("Behavior");
    
    ImGui.TableSetColumnIndex(_columnOption);
    ImGui.Text("Set");
    
    ImGui.TableSetColumnIndex(_columnValue);
    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(_columnValue));
    if (ImGui.BeginCombo("##Behavior " + _id, _behavior, ImGuiComboFlags.None))
    {
        var _i = 0;
        repeat(array_length(_behaviorArray))
        {
            var _behaviorName = _behaviorArray[_i];
            if (ImGui.Selectable(_behaviorName + "##Behavior Option " + _id, (_behavior == _behaviorName)))
            {
                __VinylDocument().__Write(_dataStruct, "__behavior", _behaviorName);
            }
                    
            ++_i;
        }
                
        ImGui.EndCombo();
    }
}