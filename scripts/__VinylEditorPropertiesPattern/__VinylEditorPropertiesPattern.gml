// Feather disable all

/// @param stateStruct
/// @param id
/// @param parentStruct
/// @param parentAssetArrayPos
/// @param name
/// @param dataStruct
/// @param constructor

function __VinylEditorPropertiesPattern(_stateStruct, _id, _parentStruct, _parentAssetArrayPos, _name, _dataStruct, _constructor)
{
    static _rootTypeArray  = ["Basic", "Shuffle", "Queue", "Multi"];
    static _childTypeArray = ["Asset", "Basic", "Shuffle", "Queue", "Multi"];
    
    static _queueBehaviorArray = ["Play Once", "Repeat Whole Queue", "Repeat Last Asset"];
    
    static _columnTree   = 0;
    static _columnDelete = 1;
    static _columnValue  = 2;
    static _columnOption = 3;
    
    var _makePopup = false;
    var _deleted = false;
    
    //Cache our type and asset array
    var _targetType  = _dataStruct.type;
    var _assetsArray = _dataStruct.assets;
    
    //We're a child if we have a valid parent
    if (_parentStruct == undefined)
    {
        var _isChild = false;
    }
    else
    {
        var _parentAssetArray = _parentStruct.assets;
        var _isChild = is_array(_parentAssetArray);
    }
    
    //Decide on what pattern types are valid for use based on whether we're a child or not
    var _typeArray = _isChild? _childTypeArray : _rootTypeArray;
    
    //TODO - Have global access to these arrays
    var _animCurveArray = ["acSmoothCrossfade"];
    var _globalAssetArray = [__VINYL_ASSET_NULL, "sndWhistle", "sndRocket", "sndNews"];
    
    //Start building this node!
    //First up - our name
    ImGui.TableNextRow();
    ImGui.TableSetColumnIndex(_columnTree);
    
    if (_targetType == "Asset")
    {
        //Special appearance for assets since they are the leaf nodes for patterns
        var _open = false;
        ImGui.Text(_name);
    }
    else
    {
        //Other patterns have more stuff going on so we want to be able to fold them
        var _open = ImGui.TreeNode(_name + "##" + _id);
    }
    
    //Add the delete [-] button to the second column so we can delete ourselves :(
    ImGui.TableSetColumnIndex(_columnDelete);
    if (ImGui.Button("-##Delete " + _id))
    {
        if (_isChild)
        {
            array_delete(_parentAssetArray, _parentAssetArrayPos, 1);
            _deleted = true;
        }
        else
        {
            variable_struct_remove(__VinylDocument().__data.patterns, _name);
            _deleted = true;
        }
    }
    
    if (not _isChild)
    {
        ImGui.SameLine();
        if (ImGui.Button("Rename##Rename " + _id))
        {
            _makePopup = true;
            
            with(_stateStruct.__popupData)
            {
                __tempName = _name;
            }
        }
    }
    
    //If we're a child, also add order up/order down buttons (but not if the parent is a Shuffle pattern because that's pointless)
    if (_isChild && (_parentStruct.type != "Shuffle"))
    {
        ImGui.SameLine();
        ImGui.BeginDisabled(_parentAssetArrayPos >= array_length(_parentAssetArray)-1);
            if (ImGui.ArrowButton("Order Down " + _id, ImGuiDir.Down))
            {
                var _temp = _parentAssetArray[_parentAssetArrayPos+1];
                _parentAssetArray[_parentAssetArrayPos+1] = _dataStruct;
                _parentAssetArray[_parentAssetArrayPos] = _temp;
            }
        ImGui.EndDisabled();
        
        ImGui.SameLine();
        ImGui.BeginDisabled(_parentAssetArrayPos <= 0);
            if (ImGui.ArrowButton("Order Up " + _id, ImGuiDir.Up))
            {
                var _temp = _parentAssetArray[_parentAssetArrayPos-1];
                _parentAssetArray[_parentAssetArrayPos-1] = _dataStruct;
                _parentAssetArray[_parentAssetArrayPos] = _temp;
            }
        ImGui.EndDisabled();
    }
    
    //If we're not a child then allow renaming if the node is open
    if (_open && (not _isChild))
    {
        ImGui.TableSetColumnIndex(_columnValue);
        var _newName = ImGui.InputText("##Name " + _id, _name);
        if (ImGui.IsItemDeactivatedAfterEdit() && (_newName != _name))
        {
            if (false)
            {
                //TODO - Build name pop-up
            }
            else
            {
                __VinylTrace("Renamed \"", _name, "\" to \"", _newName, "\"");
            }
        }
    }
    
    if (not _open)
    {
        //When closed, display a brief overview of the assets that the pattern is using
        //We don't do this for Asset-type patterns as that'd conflict with the asset assignment combo box
        if (_targetType != "Asset")
        {
            ImGui.TableSetColumnIndex(_columnValue);
            ImGui.Text(__VinylPatternGetAbbreviatedName(_dataStruct));
        }
        
        //Root patterns display their type in text when closed too
        if (not _isChild)
        {
            ImGui.TableSetColumnIndex(_columnOption);
            ImGui.Text(_targetType);
        }
    }
    
    if (_open || _isChild)
    {
        //If we're 1) a root pattern and we're open or 2) we're a child pattern, then show a pattern type combo box
        
        ImGui.TableSetColumnIndex(_columnOption);
        if (ImGui.BeginCombo("##Type Combo " + _id, _targetType, ImGuiComboFlags.None))
        {
            var _i = 0;
            repeat(array_length(_typeArray))
            {
                var _type = _typeArray[_i];
                if (ImGui.Selectable(_type + "##Type Selectable " + _type + " " + _id, (_targetType == _type)))
                {
                    //Manage asset array behaviour when converting between pattern types
                    if (array_length(_assetsArray) > 0)
                    {
                        if (__VinylPatternTypeGetMultiAsset(_type))
                        {
                            if (not __VinylPatternTypeGetMultiAsset(_targetType))
                            {
                                //Converting from e.g. Asset to Shuffle, convert our string asset reference to a pattern
                                var _oldAsset = _assetsArray[0];
                                var _newAsset = new __VinylClassPatternNew();
                                _newAsset.type = "Asset";
                                _newAsset.assets[0] = _oldAsset;
                                _assetsArray[0] = _newAsset;
                            }
                        }
                        else
                        {
                            if (__VinylPatternTypeGetMultiAsset(_targetType))
                            {
                                //Converting from e.g. Multi to Basic, remove all assets
                                array_resize(_assetsArray, 0);
                            }
                        }
                    }
                    
                    _dataStruct.type = _type;
                    _targetType = _type;
                }
                
                ++_i;
            }
            
            ImGui.EndCombo();
        }
    }
    
    //Asset-type patterns (which can only be child patterns) can adjust their asset without manipulating the tree node
    if (_isChild && (_targetType == "Asset"))
    {
        ImGui.TableSetColumnIndex(_columnValue);
        var _asset = (array_length(_assetsArray) > 0)? _assetsArray[0] : "";
        if (ImGui.BeginCombo("##Asset " + _id, _asset, ImGuiComboFlags.None))
        {
            var _i = 0;
            repeat(array_length(_globalAssetArray))
            {
                var _globalAssetName = _globalAssetArray[_i];
                if (ImGui.Selectable(_globalAssetName + "##Asset Combo " + _id, (_asset == _globalAssetName)))
                {
                    if (_globalAssetName == __VINYL_ASSET_NULL)
                    {
                        array_resize(_assetsArray, 0);
                    }
                    else
                    {
                        _assetsArray[0] = _globalAssetName;
                    }
                }
                    
                ++_i;
            }
            
            ImGui.EndCombo();
        }
    }
    
    if (_open)
    {
        //Special properties for particular pattern types
        switch(_targetType)
        {
            case "Asset":
            case "Basic":
            case "Shuffle":
            break;
            
            case "Queue":
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(_columnTree);
                ImGui.Text("Behavior");
                ImGui.TableSetColumnIndex(_columnValue);
                
                if (ImGui.BeginCombo("##Queue Behaviour Combo " + _id, _dataStruct.queueBehavior, ImGuiComboFlags.None))
                {
                    var _i = 0;
                    repeat(array_length(_queueBehaviorArray))
                    {
                        var _behavior = _queueBehaviorArray[_i];
                        if (ImGui.Selectable(_behavior + "##Queue Behaviour Combo " + _behavior + " " + _id, (_dataStruct.queueBehavior == _behavior)))
                        {
                            _dataStruct.queueBehavior = _behavior;
                        }
                            
                        ++_i;
                    }
                    
                    ImGui.EndCombo();
                }
            break;
            
            case "Multi":
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(_columnTree);
                ImGui.Text("Sync");
                ImGui.TableSetColumnIndex(_columnValue);
                _dataStruct.multiSync = ImGui.Checkbox("##Multi Sync " + _id, _dataStruct.multiSync);
                
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(_columnTree);
                ImGui.Text("Blend");
                ImGui.TableSetColumnIndex(_columnValue);
                _dataStruct.multiBlend = ImGui.SliderFloat("##Multi Blend " + _id, _dataStruct.multiBlend, 0, 1);
                
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(_columnTree);
                ImGui.Text("Blend Curve");
                ImGui.TableSetColumnIndex(_columnValue);
                if (ImGui.BeginCombo("##Multi Blend Curve " + _id, _dataStruct.multiBlendCurveName, ImGuiComboFlags.None))
                {
                    var _i = 0;
                    repeat(array_length(_animCurveArray))
                    {
                        var _animCurveName = _animCurveArray[_i];
                        if (ImGui.Selectable(_behavior + "##Multi Blend Curve " + _animCurveName + " " + _id, (_dataStruct.multiBlendCurveName == _animCurveName)))
                        {
                            _dataStruct.multiBlendCurveName = _animCurveName;
                        }
                            
                        ++_i;
                    }
                    
                    ImGui.EndCombo();
                }
            break;
            
            default:
                __VinylError("Pattern type \"", _targetType, "\" not recognised");
            break;
        }
        
        //Generic properties for all patterns
        //Asset-type patterns are strictly simple links so we don't need to display all this crap for that type of pattern
        if (_targetType != "Asset")
        {
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(_columnTree);
            var _propertiesOpen = ImGui.TreeNode("Properties##Properties Tree Node " + _id);
            ImGui.TableSetColumnIndex(_columnValue);
            
            if (_propertiesOpen)
            {
                __VinylEditorPropWidgetGain(_id, _dataStruct, _parentStruct);
                __VinylEditorPropWidgetPitch(_id, _dataStruct, _parentStruct);
                __VinylEditorPropWidgetLoop(_id, _dataStruct, _parentStruct);
                __VinylEditorPropWidgetTranspose(_id, _dataStruct, _parentStruct);
                __VinylEditorPropWidgetStack(_id, _dataStruct, _parentStruct);
                __VinylEditorPropWidgetEffectChain(_id, _dataStruct, _parentStruct);
                __VinylEditorPropWidgetLabel(_id, _dataStruct, _parentStruct);
                __VinylEditorPropWidgetPersistent(_id, _dataStruct, _parentStruct);
                
                ImGui.TreePop();
            }
            
            if (__VinylPatternTypeGetMultiAsset(_targetType))
            {
                //For pattern types that are expected to have children, show those nodes
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(_columnTree);
                ImGui.Text("Children");
                ImGui.SameLine();
                if (ImGui.SmallButton("+##Add Child " + _id))
                {
                    var _child = new _constructor();
                    _child.type = "Asset";
                    array_push(_dataStruct.assets, _child);
                }
                
                ImGui.TreePush();
                
                var _i = 0;
                repeat(array_length(_assetsArray))
                {
                    var _child = _assetsArray[_i];
                    
                    if (__VinylEditorPropertiesPattern(_stateStruct, _id + "/" + string(_i), _dataStruct, _i, _child.type + " " + string(_i+1), _child, _constructor))
                    {
                        ++_i;
                    }
                }
                
                ImGui.TreePop();
            }
            else
            {
                //Show an asset selection combo box for Basic-type patterns
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(_columnTree);
                ImGui.Text("Asset");
                ImGui.TableSetColumnIndex(_columnValue);
                
                var _asset = (array_length(_assetsArray) > 0)? _assetsArray[0] : "";
                if (ImGui.BeginCombo("##Asset " + _id, _asset, ImGuiComboFlags.None))
                {
                    var _i = 0;
                    repeat(array_length(_globalAssetArray))
                    {
                        var _globalAssetName = _globalAssetArray[_i];
                        if (ImGui.Selectable(_globalAssetName + "##Asset Combo " + _id, (_asset == _globalAssetName)))
                        {
                            if (_globalAssetName == __VINYL_ASSET_NULL)
                            {
                                array_resize(_assetsArray, 0);
                            }
                            else
                            {
                                _assetsArray[0] = _globalAssetName;
                            }
                        }
                        
                        ++_i;
                    }
                    
                    ImGui.EndCombo();
                }
            }
        }
        
        ImGui.TreePop();
    }
    
    if (not _isChild)
    {
        if (_makePopup)
        {
            ImGui.OpenPopup("Rename");
        }
        
        ImGui.SetNextWindowPos(window_get_width() / 2, window_get_height () / 2, ImGuiCond.Appearing, 0.5, 0.5);
        
        if (ImGui.BeginPopupModal("Rename", undefined, ImGuiWindowFlags.NoResize))
        {
            ImGui.Text("Please enter a new name for \"" + _name + "\"");
            
            ImGui.Separator();
            
            _stateStruct.__popupData.__tempName = ImGui.InputText("##Rename Field", _stateStruct.__popupData.__tempName);
            
            if (ImGui.Button("Accept"))
            {
                if (_stateStruct.__popupData.__tempName != _name)
                {
                    var _rootStruct = __VinylDocument().__data.patterns;
                    variable_struct_remove(_rootStruct, _name);
                    _rootStruct[$ _stateStruct.__popupData.__tempName] = _dataStruct;
                }
                
                ImGui.CloseCurrentPopup();
            }
            
            ImGui.SameLine(undefined, 40);
            if (ImGui.Button("Cancel")) ImGui.CloseCurrentPopup();
            ImGui.EndPopup();	
        }
    }
            
    return not _deleted;
}