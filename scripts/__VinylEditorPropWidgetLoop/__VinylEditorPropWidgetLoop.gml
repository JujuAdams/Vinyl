// Feather disable all

/// @param UiID
/// @param dataStruct
/// @param parentStruct
/// @param columnName
/// @param columnValue
/// @param columnOption
/// @param showLoopPoints

function __VinylEditorPropWidgetLoop(_id, _dataStruct, _parentStruct, _columnName, _columnValue, _columnOption, _showLoopPoints)
{
    static _optionArray = [__VINYL_OPTION_UNSET, __VINYL_OPTION_OVERRIDE];
    
    var _originalOption = (_dataStruct == undefined)? __VINYL_OPTION_UNSET : _dataStruct.loopOption;
    var _inheriting = (_originalOption == __VINYL_OPTION_UNSET);
    
    var _resolution = __VinylPatternResolveInheritedLoop(_dataStruct, _parentStruct);
    var _loopOption = _resolution.__option;
    var _loop       = _resolution.__value;
    
    ImGui.TableNextRow();
    ImGui.TableSetColumnIndex(_columnName);
    ImGui.Text("Loop");
    
    ImGui.TableSetColumnIndex(_columnValue);
    ImGui.BeginDisabled(_inheriting);
        switch(_loopOption)
        {
            case __VINYL_OPTION_OVERRIDE:
                var _newValue = ImGui.Checkbox("##Loop " + _id, _loop);
                
                if (not _inheriting)
                {
                    _dataStruct.loop = _newValue;
                }
            break;
        }
    ImGui.EndDisabled();
    
    ImGui.TableSetColumnIndex(_columnOption);
    if (ImGui.BeginCombo("##Loop Option " + _id, _originalOption, ImGuiComboFlags.None))
    {
        var _i = 0;
        repeat(array_length(_optionArray))
        {
            var _optionName = _optionArray[_i];
            if (ImGui.Selectable(_optionName + "##Loop Option " + _id, (_originalOption == _optionName)))
            {
                _dataStruct.loopOption = _optionName;
            }
                        
            ++_i;
        }
        
        ImGui.EndCombo();
    }
    
    if (_showLoopPoints && _loop)
    {
        var _originalOption = (_dataStruct == undefined)? __VINYL_OPTION_UNSET : _dataStruct.loopPointsOption;
        var _inheriting = (_originalOption == __VINYL_OPTION_UNSET);
        
        var _resolution = __VinylPatternResolveInheritedLoopPoints(_dataStruct, _parentStruct);
        var _loopPointsOption = _resolution.__option;
        var _loopPoints       = _resolution.__value;
        
        ImGui.TableNextRow();
        ImGui.TableSetColumnIndex(_columnName);
        ImGui.Text("Loop Points");
        
        ImGui.TableSetColumnIndex(_columnValue);
        ImGui.BeginDisabled(_inheriting);
            switch(_loopPointsOption)
            {
                case __VINYL_OPTION_OVERRIDE:
                    var _newValue = variable_clone(_loopPoints);
                    ImGui.InputFloat2("seconds##Loop Points " + _id, _newValue, 0, 2);
                    
                    if ((not _inheriting) && (not array_equals(_loopPoints, _newValue)))
                    {
                        if (_newValue[0] < _newValue[1])
                        {
                            _loopPoints[0] = _newValue[0];
                            _loopPoints[1] = _newValue[1];
                        }
                        else
                        {
                            //If the two values have inverted, correct that
                            _loopPoints[0] = _newValue[1];
                            _loopPoints[1] = _newValue[0];
                        }
                    }
                break;
            }
        ImGui.EndDisabled();
    
        ImGui.TableSetColumnIndex(_columnOption);
        if (ImGui.BeginCombo("##Loop Points Option " + _id, _originalOption, ImGuiComboFlags.None))
        {
            var _i = 0;
            repeat(array_length(_optionArray))
            {
                var _optionName = _optionArray[_i];
                if (ImGui.Selectable(_optionName + "##Loop Points Option " + _id, (_originalOption == _optionName)))
                {
                    _dataStruct.loopPointsOption = _optionName;
                }
                        
                ++_i;
            }
            
            ImGui.EndCombo();
        }
    }
}