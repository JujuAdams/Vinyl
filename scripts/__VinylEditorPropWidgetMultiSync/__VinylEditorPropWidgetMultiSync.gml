// Feather disable all

/// @param UiID
/// @param dataStruct
/// @param parentStruct
/// @param columnName
/// @param columnValue
/// @param columnOption

function __VinylEditorPropWidgetMultiSync(_id, _dataStruct, _parentStruct, _columnName, _columnValue, _columnOption)
{
    static _optionArray = [__VINYL_OPTION_UNSET, __VINYL_OPTION_SET];
    
    ImGui.TableNextRow();
    ImGui.TableSetColumnIndex(_columnName);
    ImGui.Text("Sync");
    
    ImGui.TableSetColumnIndex(_columnOption);
    ImGui.Text("Set");
    
    ImGui.TableSetColumnIndex(_columnValue);
    var _newValue = ImGui.Checkbox("##Sync " + _id, _dataStruct.__sync);
    __VinylDocument().__Write(_dataStruct, "__sync", _newValue);
}