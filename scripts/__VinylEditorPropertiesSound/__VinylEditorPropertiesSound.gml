// Feather disable all

function __VinylEditorPropertiesSound(_soundName, _soundData, _modified, _defaultData, _selectionHandler, _patternDict)
{
    //Fallback handling
    if (not _modified)
    {
        _soundData = _defaultData;
        _defaultData = undefined;
    }
    
    ImGui.BeginDisabled(not _modified);
        _soundData.__BuildPropertyUI(_selectionHandler);
    ImGui.EndDisabled();
    
    ImGui.NewLine();
    
    //All the GameMaker properties
    if (_soundName != __VINYL_FALLBACK_NAME)
    {
        if (ImGui.BeginTable("GameMaker Properties", 2, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 160))
        {
            var _projectSound = __VinylDocument().__GetProjectSoundDictionary()[$ _soundName];
            
            //Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("GameMaker Project", ImGuiTableColumnFlags.WidthStretch, 0.55);
            ImGui.TableSetupColumn("Compiled", ImGuiTableColumnFlags.WidthStretch, 0.45);
            ImGui.TableHeadersRow();
            
            
            
            //Audio group drop-down
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.SetNextItemWidth(ImGui.GetContentRegionAvailX());
            if (ImGui.BeginCombo("##Audio Group", _projectSound.__audioGroup, ImGuiComboFlags.None))
            {
                var _audioGroupArray = __VinylDocument().__GetProjectAudioGroupArray();
                var _i = 0;
                repeat(array_length(_audioGroupArray))
                {
                    var _audioGroup = _audioGroupArray[_i];
                    if (ImGui.Selectable(_audioGroup, _projectSound.__audioGroup == _audioGroup))
                    {
                        _selectionHandler.__ForEachSelected(method({
                            __audioGroup: _audioGroup,
                        }, function(_name, _struct)
                        {
                            _struct.__SetAudioGroup(__audioGroup);
                        }));
                    }
                    
                    ++_i;
                }
                
                ImGui.EndCombo();
            }
            
            //Audio group that we extracted from the project file(s)
            ImGui.TableSetColumnIndex(1);
            if (_projectSound.__compiledValues)
            {
                if (_projectSound.__compiledAttributes != 3)
                {
                    ImGui.Text(_projectSound.__compiledAudioGroup);
                }
                else
                {
                    ImGui.Text("N/A");
                }
            }
            else
            {
                ImGui.Text("Added after compile");
            }
            
            
            
            //Asset tag drop-down
            var _soundAssetTags = _projectSound.__assetTags;
            
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.SetNextItemWidth(ImGui.GetContentRegionAvailX());
            if (ImGui.BeginCombo("##Asset Tag", __VinylAssetTagsGetAbbreviatedName(_soundAssetTags), ImGuiComboFlags.None))
            {
                var _assetTagArray = __VinylDocument().__GetProjectAssetTagArray();
                var _i = 0;
                repeat(array_length(_assetTagArray))
                {
                    var _assetTag = _assetTagArray[_i];
                    
                    var _oldValue = array_contains(_soundAssetTags, _assetTag);
                    var _newValue = ImGui.Checkbox(_assetTag + "##Asset Tag Checkbox", _oldValue);
                    
                    if (_oldValue != _newValue)
                    {
                        _selectionHandler.__ForEachSelected(method({
                            __assetTag: _assetTag,
                            __newValue: _newValue,
                        }, function(_name, _struct)
                        {
                            _struct.__SetAssetTag(__assetTag, __newValue);
                        }));
                    }
                    
                    ++_i;
                }
                
                ImGui.EndCombo();
            }
            
            //Audio group that we extracted from the project file(s)
            ImGui.TableSetColumnIndex(1);
            if (_projectSound.__compiledValues)
            {
                var _compiledAssetTags = _projectSound.__compiledAssetTags;
                if (array_length(_compiledAssetTags) <= 0)
                {
                    ImGui.Text("<No asset tags>");
                }
                else
                {
                    ImGui.Text(__VinylAssetTagsGetAbbreviatedName(_compiledAssetTags));
                }
            }
            else
            {
                ImGui.Text("Added after compile");
            }
            
            
            
            //WAV compression option
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            if (ImGui.RadioButton("WAV", (_projectSound.__attributes == 0)))
            {
                _selectionHandler.__ForEachSelected(method({
                    __attributes: 0,
                }, function(_name, _struct)
                {
                    _struct.__SetAttributes(__attributes);
                }));
            }
            
            if (_projectSound.__compiledValues)
            {
                ImGui.BeginDisabled(true);
                    ImGui.TableSetColumnIndex(1);
                    ImGui.RadioButton("", (_projectSound.__compiledAttributes == 0));
                ImGui.EndDisabled();
            }
            
            
            
            //OGG variant 1 compression option
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            if (ImGui.RadioButton("OGG - Decompress during playback", (_projectSound.__attributes == 1)))
            {
                _selectionHandler.__ForEachSelected(method({
                    __attributes: 1,
                }, function(_name, _struct)
                {
                    _struct.__SetAttributes(__attributes);
                }));
            }
            
            if (_projectSound.__compiledValues)
            {
                ImGui.BeginDisabled(true);
                    ImGui.TableSetColumnIndex(1);
                    ImGui.RadioButton("", (_projectSound.__compiledAttributes == 1));
                ImGui.EndDisabled();
            }
            
            
            
            //OGG variant 2 compression option
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            if (ImGui.RadioButton("OGG - Decompress when loaded and store in RAM", (_projectSound.__attributes == 2)))
            {
                _selectionHandler.__ForEachSelected(method({
                    __attributes: 2,
                }, function(_name, _struct)
                {
                    _struct.__SetAttributes(__attributes);
                }));
            }
            
            if (_projectSound.__compiledValues)
            {
                ImGui.BeginDisabled(true);
                    ImGui.TableSetColumnIndex(1);
                    ImGui.RadioButton("", (_projectSound.__compiledAttributes == 2));
                ImGui.EndDisabled();
            }
            
            
            
            //OGG variant 3 compression option
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            if (ImGui.RadioButton("OGG - Stream from disk (exports .ogg files)", (_projectSound.__attributes == 3)))
            {
                _selectionHandler.__ForEachSelected(method({
                    __attributes: 3,
                }, function(_name, _struct)
                {
                    _struct.__SetAttributes(__attributes);
                }));
            }
            
            if (_projectSound.__compiledValues)
            {
                ImGui.BeginDisabled(true);
                    ImGui.TableSetColumnIndex(1);
                    ImGui.RadioButton("", (_projectSound.__compiledAttributes == 3));
                ImGui.EndDisabled();
            }
            
            
            
            //We're done!
            ImGui.EndTable();
        }
    }
}