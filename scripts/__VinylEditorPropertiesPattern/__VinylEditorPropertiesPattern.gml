// Feather disable all

/// @param id
/// @param isChild
/// @param name
/// @param dataStruct
/// @param constructor

function __VinylEditorPropertiesPattern(_id, _isChild, _name, _dataStruct, _constructor)
{
    static _rootTypeArray  = ["Basic", "Shuffle", "Queue", "Multi"];
    static _childTypeArray = ["Asset", "Basic", "Shuffle", "Queue", "Multi"]
    
    static _queueBehaviorArray = ["Play Once", "Repeat Whole Queue", "Repeat Last Asset"];
    
    var _targetType = _dataStruct.type;
    
    var _typeArray = _isChild? _childTypeArray : _rootTypeArray;
    var _animCurveArray = ["acSmoothCrossfade"];
    var _globalAssetArray = [__VINYL_ASSET_NULL, "sndWhistle", "sndRocket", "sndNews"];
    
    static _columnTree   = 0;
    static _columnDelete = 1;
    static _columnValue  = 2;
    static _columnKnob   = 3;
    
    var _assetsArray = _dataStruct.assets;
    
    ImGui.TableNextRow();
    ImGui.TableSetColumnIndex(_columnTree);
    
    if (_targetType == "Asset")
    {
        var _open = false;
        ImGui.TreeNodeEx(_name + "##" + _id, ImGuiTreeNodeFlags.Bullet | ImGuiTreeNodeFlags.NoTreePushOnOpen);
    }
    else
    {
        var _open = ImGui.TreeNode(_name + "##" + _id);
    }
    
    ImGui.TableSetColumnIndex(_columnDelete);
    if (ImGui.Button("-##Delete " + _id))
    {
        if (_isChild)
        {
            
        }
    }
    
    if (_isChild)
    {
        ImGui.SameLine();
        if (ImGui.ArrowButton("Order Down " + _id, ImGuiDir.Down))
        {
            
        }
        
        ImGui.SameLine();
        if (ImGui.ArrowButton("Order Up " + _id, ImGuiDir.Up))
        {
            
        }
    }
    else
    {
        ImGui.TableSetColumnIndex(_columnValue);
        if (_open)
        {
            ImGui.InputText("##Name " + _id, _name);
        }
        else
        {
            ImGui.Text(_name);
        }
    }
    
    if (not _open && (not _isChild))
    {
        ImGui.TableSetColumnIndex(_columnKnob);
        ImGui.Text(_targetType);
    }
    else
    {
        ImGui.TableSetColumnIndex(_columnKnob);
        if (ImGui.BeginCombo("##Type Combo " + _id, _targetType, ImGuiComboFlags.None))
        {
            var _i = 0;
            repeat(array_length(_typeArray))
            {
                var _type = _typeArray[_i];
                if (ImGui.Selectable(_type + "##Type Selectable " + _type + " " + _id, (_targetType == _type)))
                {
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
                }
                
                ++_i;
            }
            
            ImGui.EndCombo();
        }
    }
    
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
        var _assetsOpen = false;
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
        
        if (_targetType != "Asset")
        {
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(_columnTree);
            var _propertiesOpen = ImGui.TreeNode("Properties##Properties Tree Node " + _id);
            ImGui.TableSetColumnIndex(_columnValue);
            
            if (_propertiesOpen)
            {
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(_columnTree);
                ImGui.Text("Gain");
                ImGui.TableSetColumnIndex(_columnValue);
                _dataStruct.gain = ImGui.SliderFloat("##Gain " + _id, _dataStruct.gain, 0, 2);
            
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(_columnTree);
                ImGui.Text("Pitch");
                ImGui.TableSetColumnIndex(_columnValue);
                _dataStruct.pitch = ImGui.SliderFloat("##Pitch " + _id, _dataStruct.pitch, 0.5, 2);
            
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(_columnTree);
                ImGui.Text("Transpose");
                ImGui.TableSetColumnIndex(_columnValue);
                _dataStruct.transpose = ImGui.SliderInt("##Transpose " + _id, _dataStruct.transpose, -24, 24);
            
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(_columnTree);
                ImGui.Text("Loop");
                ImGui.TableSetColumnIndex(_columnValue);
                _dataStruct.loop = ImGui.Checkbox("##Loop " + _id, _dataStruct.loop);
            
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(_columnTree);
                ImGui.Text("Stack");
                ImGui.TableSetColumnIndex(_columnValue);
                _dataStruct.stack = ImGui.InputText("##Stack " + _id, _dataStruct.stack);
            
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(_columnTree);
                ImGui.Text("Stack Priority");
                ImGui.TableSetColumnIndex(_columnValue);
                _dataStruct.stackPriority = ImGui.InputInt("##Stack Priority " + _id, _dataStruct.stackPriority);
            
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(_columnTree);
                ImGui.Text("Effect Chain");
                ImGui.TableSetColumnIndex(_columnValue);
                _dataStruct.effectChain = ImGui.InputText("##Effect Chain " + _id, _dataStruct.effectChain);
            
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(_columnTree);
                ImGui.Text("Label");
                ImGui.TableSetColumnIndex(_columnValue);
            
                var _labelString = "";
                if (ImGui.BeginCombo("##Label " + _id, _labelString, ImGuiComboFlags.None))
                {
                    ImGui.EndCombo();
                }
            
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(_columnTree);
                ImGui.Text("Persistent");
                ImGui.TableSetColumnIndex(_columnValue);
                _dataStruct.persistent = ImGui.Checkbox("##Persistent " + _id, _dataStruct.persistent);
                
                ImGui.TreePop();
            }
        }
        
        if (_targetType == "Basic")
        {
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
        else if (_targetType != "Asset")
        {
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(_columnTree);
            ImGui.Text("Assets");
            
            ImGui.TreePush();
            
            ImGui.TableSetColumnIndex(_columnDelete);
            if (ImGui.Button("+##Add Child " + _id))
            {
                var _child = new _constructor();
                _child.type = "Asset";
                array_push(_dataStruct.assets, _child);
            }
                
            var _i = 0;
            repeat(array_length(_assetsArray))
            {
                var _child = _assetsArray[_i];
                __VinylEditorPropertiesPattern(_id + "/" + string(_i), true, _child.type + " " + string(_i+1), _child, _constructor);
                ++_i;
            }
                
            ImGui.TreePop();
        }
        
        ImGui.TreePop();
    }
}