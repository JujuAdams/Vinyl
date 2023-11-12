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
    
    var _width = ImGui.GetContentRegionAvailX();
    ImGui.BeginChild("GameMaker Native Properties", _width, 130, true);
    
        ImGui.TextUnformatted("Audiogroup");
        ImGui.SameLine();
        if (ImGui.BeginCombo("##Audiogroup", "Default", ImGuiComboFlags.None))
        {
            ImGui.Selectable("Default", true);
            ImGui.Selectable("agBaddies", false);
            ImGui.Selectable("agFX", false);
            ImGui.EndCombo();
        }
        
        ImGui.RadioButton("WAV", true);
        ImGui.RadioButton("OGG - Decompress during playback", false);
        ImGui.RadioButton("OGG - Decompress when loaded and store in RAM", false);
        ImGui.RadioButton("OGG - Stream from disk (exports .ogg files in game directory)", false);
        
    ImGui.EndChild();
}