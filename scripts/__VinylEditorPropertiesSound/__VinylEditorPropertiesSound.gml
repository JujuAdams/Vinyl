// Feather disable all

function __VinylEditorPropertiesSound(_soundName, _soundData, _modified, _defaultData, _selectionHandler, _patternDict)
{
    var _showApply = (_modified && (_selectionHandler.__GetSelectedCount() > 1));
    
    //Fallback handling
    if (not _modified)
    {
        _soundData = _defaultData;
        _defaultData = undefined;
    }
    
    //For easier reading, all the widgets are handled by parsing this array!
    static _displayWidgetArray = [
        { __name: "Gain",         __function: __VinylEditorPropWidgetGain,        __apply: ["__gainOption", "__gainKnob", "__gainKnobOverride", "__gain"], },
        { __name: "Pitch",        __function: __VinylEditorPropWidgetPitch,       __apply: ["__pitchOption", "__pitchKnob", "__pitchKnobOverride", "__pitch"], },
        { __name: "Loop",         __function: __VinylEditorPropWidgetLoop,        __apply: ["__loopOption", "__loop", "__loopPointsOption", "__loopPoints"], },
        { __name: "Labels",       __function: __VinylEditorPropWidgetLabel,       __apply: ["__labelsOption", "__labels"], },
        { __name: "Stack",        __function: __VinylEditorPropWidgetStack,       __apply: ["__stackOption", "__stackName", "__stackPriority"], },
        { __name: "Effect Chain", __function: __VinylEditorPropWidgetEffectChain, __apply: ["__effectChainOption", "__effectChain"], },
        { __name: "Persistent",   __function: __VinylEditorPropWidgetPersistent,  __apply: ["__persistentOption", "__persistent"], },
        { __name: "BPM",          __function: __VinylEditorPropWidgetBPM,         __apply: ["__bpmOption", "__bpm"], },
        { __name: "Transpose",    __function: __VinylEditorPropWidgetTranspose,   __apply: ["__transposeOption", "__transposeKnob", "__transposeKnobOverride", "__transpose"], },
    ];
    
    ImGui.BeginDisabled(not _modified);
        
        //Now do the actual table
        if (ImGui.BeginTable("Vinyl Properties", 4, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 280))
        {
            //Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("Name",   ImGuiTableColumnFlags.WidthFixed, 100);
            ImGui.TableSetupColumn("Option", ImGuiTableColumnFlags.WidthFixed, 125);
            ImGui.TableSetupColumn("Value",  ImGuiTableColumnFlags.WidthStretch, 1);
            ImGui.TableSetupColumn("Apply",  ImGuiTableColumnFlags.WidthFixed, 80);
            
            //Make aaaall the widgets
            var _i = 0;
            repeat(array_length(_displayWidgetArray))
            {
                var _displayWidget = _displayWidgetArray[_i];
                _displayWidget.__function(_soundName, _soundData, _defaultData, 0, 2, 1);
                
                if (_showApply)
                {
                    ImGui.TableSetColumnIndex(3);
                    if (ImGui.Button("Apply##" + _displayWidget.__name))
                    {
                        __VinylEditorApply(_soundData, _selectionHandler, _patternDict, _displayWidget.__apply);
                    }
                }
                
                ++_i;
            }
            
            //Top it off with an extra Apply All button if we're in multi-selection mode
            if (_showApply)
            {
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(3);
                if (ImGui.Button("Apply All"))
                {
                    __VinylEditorApplyAll(_soundData, _selectionHandler, _patternDict);
                }
            }
            
            ImGui.EndTable();
        }
        
    ImGui.EndDisabled();
    
    ImGui.NewLine();
    
    //All the GameMaker properties
    if (_soundName != __VINYL_FALLBACK_NAME)
    {
        if (ImGui.BeginTable("GameMaker Properties", 2, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 140))
        {
            var _projectSound = __VinylDocument().__projectSoundDictionary[$ _soundName];
            
            //Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("GameMaker Project", ImGuiTableColumnFlags.WidthStretch, 5);
            ImGui.TableSetupColumn("Compiled", ImGuiTableColumnFlags.WidthStretch, 2);
            ImGui.TableHeadersRow();
            
            //Audio group drop-down
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