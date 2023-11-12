// Feather disable all

function __VinylEditorPropertiesSound(_soundName, _soundData, _modified, _defaultData, _selectionHandler, _modifiedSoundDict)
{
    var _showApply = (_modified && (_selectionHandler.__GetSelectedCount() > 1));
    
    if (not _modified)
    {
        _soundData = _defaultData;
        _defaultData = undefined;
    }
    
    ImGui.BeginDisabled(not _modified);
        //Now do the actual table
        if (ImGui.BeginTable("Vinyl Properties", 4, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 280))
        {
            //Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("Name",   ImGuiTableColumnFlags.WidthFixed, 100);
            ImGui.TableSetupColumn("Option", ImGuiTableColumnFlags.WidthFixed, 125);
            ImGui.TableSetupColumn("Value",  ImGuiTableColumnFlags.WidthStretch, 1);
            ImGui.TableSetupColumn("Apply",  ImGuiTableColumnFlags.WidthFixed, 80);
            
            __VinylEditorPropWidgetGain(_soundName, _soundData, _defaultData, 0, 2, 1);
            
            if (_showApply)
            {
                ImGui.TableSetColumnIndex(3);
                if (ImGui.Button("Apply##Gain"))
                {
                    __VinylEditorApply(_soundData, _selectionHandler, _modifiedSoundDict, ["gainOption", "gainKnob", "gainKnobOverride", "gain"]);
                }
            }
            
            __VinylEditorPropWidgetPitch(_soundName, _soundData, _defaultData, 0, 2, 1);
            
            if (_showApply)
            {
                ImGui.TableSetColumnIndex(3);
                if (ImGui.Button("Apply##Pitch"))
                {
                    __VinylEditorApply(_soundData, _selectionHandler, _modifiedSoundDict, ["pitchOption", "pitchKnob", "pitchKnobOverride", "pitch"]);
                }
            }
            
            __VinylEditorPropWidgetLoop(_soundName, _soundData, _defaultData, 0, 2, 1, true);
            
            if (_showApply)
            {
                ImGui.TableSetColumnIndex(3);
                if (ImGui.Button("Apply##Loop"))
                {
                    __VinylEditorApply(_soundData, _selectionHandler, _modifiedSoundDict, ["loopOption", "loop", "loopPointsOption", "loopPoints"]);
                }
            }
            
            __VinylEditorPropWidgetLabel(_soundName, _soundData, _defaultData, 0, 2, 1);
            
            if (_showApply)
            {
                ImGui.TableSetColumnIndex(3);
                if (ImGui.Button("Apply##Labels"))
                {
                    __VinylEditorApply(_soundData, _selectionHandler, _modifiedSoundDict, ["labelsOption", "labels"]);
                }
            }
            
            __VinylEditorPropWidgetStack(_soundName, _soundData, _defaultData, 0, 2, 1);
            
            if (_showApply)
            {
                ImGui.TableSetColumnIndex(3);
                if (ImGui.Button("Apply##Stack"))
                {
                    __VinylEditorApply(_soundData, _selectionHandler, _modifiedSoundDict, ["stackOption", "stack", "stackPriority"]);
                }
            }
            
            __VinylEditorPropWidgetEffectChain(_soundName, _soundData, _defaultData, 0, 2, 1);
            
            if (_showApply)
            {
                ImGui.TableSetColumnIndex(3);
                if (ImGui.Button("Apply##Effect Chain"))
                {
                    __VinylEditorApply(_soundData, _selectionHandler, _modifiedSoundDict, ["effectChainOption", "effectChain"]);
                }
            }
            
            __VinylEditorPropWidgetPersistent(_soundName, _soundData, _defaultData, 0, 2, 1);
            
            if (_showApply)
            {
                ImGui.TableSetColumnIndex(3);
                if (ImGui.Button("Apply##Persistent"))
                {
                    __VinylEditorApply(_soundData, _selectionHandler, _modifiedSoundDict, ["persistentOption", "persistent"]);
                }
            }
            
            __VinylEditorPropWidgetBPM(_soundName, _soundData, _defaultData, 0, 2, 1);
            
            if (_showApply)
            {
                ImGui.TableSetColumnIndex(3);
                if (ImGui.Button("Apply##BPM"))
                {
                    __VinylEditorApply(_soundData, _selectionHandler, _modifiedSoundDict, ["bpmOption", "bpm"]);
                }
            }
            
            __VinylEditorPropWidgetTranspose(_soundName, _soundData, _defaultData, 0, 2, 1);
            
            if (_showApply)
            {
                ImGui.TableSetColumnIndex(3);
                if (ImGui.Button("Apply##Transpose"))
                {
                    __VinylEditorApply(_soundData, _selectionHandler, _modifiedSoundDict, ["transposeOption", "transposeKnob", "transposeKnobOverride", "transpose"]);
                }
            }
            
            if (_showApply)
            {
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(3);
                if (ImGui.Button("Apply All"))
                {
                    __VinylEditorApplyAll(_soundData, _selectionHandler, _modifiedSoundDict);
                }
            }
            
            ImGui.EndTable();
        }
    ImGui.EndDisabled();
    
    ImGui.NewLine();
    
    //Now do the actual table
    if (ImGui.BeginTable("GameMaker Properties", 2, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 140))
    {
        var _projectSound = __VinylDocument().__projectSoundDictionary[$ _soundName];
        
        //Set up our columns with fixed widths so we get a nice pretty layout
        ImGui.TableSetupColumn("GameMaker Project", ImGuiTableColumnFlags.WidthStretch, 5);
        ImGui.TableSetupColumn("Compiled", ImGuiTableColumnFlags.WidthStretch, 2);
        ImGui.TableHeadersRow();
        
        ImGui.TableNextRow();
        ImGui.TableSetColumnIndex(0);
        ImGui.Text("Audio Group");
        ImGui.SameLine();
        if (ImGui.BeginCombo("##Audio Group", _projectSound.__audioGroup, ImGuiComboFlags.None))
        {
            var _audioGroupArray = __VinylDocument().__ProjectGetAudioGroupArray();
            var _i = 0;
            repeat(array_length(_audioGroupArray))
            {
                var _audioGroup = _audioGroupArray[_i];
                if (ImGui.Selectable(_audioGroup, _projectSound.__audioGroup == _audioGroup))
                {
                    _projectSound.__SetAudioGroup(_audioGroup);
                }
                
                ++_i;
            }
            
            ImGui.EndCombo();
        }
        
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
        
        ImGui.TableNextRow();
        ImGui.TableSetColumnIndex(0);
        if (ImGui.RadioButton("WAV", (_projectSound.__attributes == 0)))
        {
            _projectSound.__SetAttributes(0);
        }
        
        if (_projectSound.__compiledValues)
        {
            ImGui.BeginDisabled(true);
                ImGui.TableSetColumnIndex(1);
                ImGui.RadioButton("", (_projectSound.__compiledAttributes == 0));
            ImGui.EndDisabled();
        }
        
        ImGui.TableNextRow();
        ImGui.TableSetColumnIndex(0);
        if (ImGui.RadioButton("OGG - Decompress during playback", (_projectSound.__attributes == 1)))
        {
            _projectSound.__SetAttributes(1);
        }
        
        if (_projectSound.__compiledValues)
        {
            ImGui.BeginDisabled(true);
                ImGui.TableSetColumnIndex(1);
                ImGui.RadioButton("", (_projectSound.__compiledAttributes == 1));
            ImGui.EndDisabled();
        }
        
        ImGui.TableNextRow();
        ImGui.TableSetColumnIndex(0);
        if (ImGui.RadioButton("OGG - Decompress when loaded and store in RAM", (_projectSound.__attributes == 2)))
        {
            _projectSound.__SetAttributes(2);
        }
        
        if (_projectSound.__compiledValues)
        {
            ImGui.BeginDisabled(true);
                ImGui.TableSetColumnIndex(1);
                ImGui.RadioButton("", (_projectSound.__compiledAttributes == 2));
            ImGui.EndDisabled();
        }
        
        ImGui.TableNextRow();
        ImGui.TableSetColumnIndex(0);
        if (ImGui.RadioButton("OGG - Stream from disk (exports .ogg files)", (_projectSound.__attributes == 3)))
        {
            _projectSound.__SetAttributes(3);
        }
        
        if (_projectSound.__compiledValues)
        {
            ImGui.BeginDisabled(true);
                ImGui.TableSetColumnIndex(1);
                ImGui.RadioButton("", (_projectSound.__compiledAttributes == 3));
            ImGui.EndDisabled();
        }
        
        ImGui.EndTable();
    }
}