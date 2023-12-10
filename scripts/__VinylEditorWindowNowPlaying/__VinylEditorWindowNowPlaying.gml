// Feather disable all

function __VinylEditorWindowNowPlaying(_stateStruct)
{
    static _globalData    = __VinylGlobalData();
    static _topLevelArray = _globalData.__topLevelArray;
    
    static _editor = __VinylGlobalData().__editor;
    if (not VinylEditorIsShowing()) return;
    
    ImGui.SetNextWindowSize(0.7*room_width, room_height/2, ImGuiCond.Once);
    ImGui.SetNextWindowPos(0.15*room_width, room_height/4, ImGuiCond.Once);
	
    var ret = ImGui.Begin("Now Playing", __VinylEditorWindowGetOpen("__nowPlaying"), undefined, ImGuiReturnMask.Both);
    __VinylEditorWindowSetOpen("__nowPlaying", (ret & ImGuiReturnMask.Pointer));
    
    if (ret & ImGuiReturnMask.Return)
    {
    	if (ImGui.BeginTabBar("Now Playing Tab Bar"))
        {
            if (ImGui.BeginTabItem("Voices"))
            {
                if (ImGui.Button("Stop All"))
                {
                    VinylStopAll();
                }
                
                ImGui.SameLine(undefined, 20);
                
                if (ImGui.Button("Stop All Non-Persistent"))
                {
                    VinylStopAllNonPersistent();
                }
                
                ImGui.SameLine(undefined, 20);
                
                ImGui.Text("Total playing: " + string(array_length(_topLevelArray)));
                
                if (ImGui.BeginTable("Voice Table", 8, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg))
                {
                    ImGui.TableSetupColumn("Name", ImGuiTableColumnFlags.WidthStretch, 2);
                    ImGui.TableSetupColumn("Pattern", ImGuiTableColumnFlags.WidthStretch, 2);
                    ImGui.TableSetupColumn("Loop", ImGuiTableColumnFlags.WidthFixed, 40);
                    ImGui.TableSetupColumn("Gain", ImGuiTableColumnFlags.WidthFixed, 40);
                    ImGui.TableSetupColumn("(Duck)", ImGuiTableColumnFlags.WidthFixed, 40);
                    ImGui.TableSetupColumn("Pitch", ImGuiTableColumnFlags.WidthFixed, 40);
                    ImGui.TableSetupColumn("(Transpose)", ImGuiTableColumnFlags.WidthFixed, 80);
                    ImGui.TableSetupColumn("Fx Chain", ImGuiTableColumnFlags.WidthFixed, 100);
                    
                    ImGui.TableHeadersRow();
                    
                    var _i = 0;
                    repeat(array_length(_topLevelArray))
                    {
                        var _voice = _topLevelArray[_i];
                        
                        ImGui.TableNextRow();
                        ImGui.TableNextColumn();
                        ImGui.Text(_voice);
                        ImGui.TableNextColumn();
                        ImGui.Text(_voice.__ParentTopLevelGet());
                        ImGui.TableNextColumn();
                        ImGui.Text(_voice.__LoopGet()? "true" : "false");
                        ImGui.TableNextColumn();
                        ImGui.Text(_voice.__GainOutputGet());
                        ImGui.TableNextColumn();
                        ImGui.Text(_voice.__gainDuck);
                        ImGui.TableNextColumn();
                        ImGui.Text(_voice.__PitchOutputGet());
                        ImGui.TableNextColumn();
                        ImGui.Text(_voice.__TransposeGet());
                        ImGui.TableNextColumn();
                        ImGui.Text(_voice.__effectChainName);
                    
                        ++_i;   
                    }
                    
                    ImGui.EndTable();
                }
                
                ImGui.EndTabItem();
            }
            
            if (ImGui.BeginTabItem("Pools"))
            {
                ImGui.Text("Pool data is provided for debugging purposes.");
                
                static _poolArray = [_globalData.__poolSound,
                                     _globalData.__poolBasic,
                                     _globalData.__poolQueue,
                                     _globalData.__poolMulti,
                                     _globalData.__poolEmitter,
                                     _globalData.__poolPanEmitter];
                                     
                static _poolNameArray = ["Sound",
                                         "Basic",
                                         "Queue",
                                         "Multi",
                                         "Emitter",
                                         "PanEmitter"];
                
                var _totalSize      = 0;
                var _totalActive    = 0;
                var _totalInactive  = 0;
                var _totalPooled    = 0;
                var _totalReturning = 0;
                
                var _i = 0;
                repeat(array_length(_poolArray))
                {
                    with(_poolArray[_i])
                    {
                        _totalSize      += __GetSize();
                        _totalActive    += __GetActiveCount();
                        _totalInactive  += __GetInactiveCount();
                        _totalPooled    += __GetPooledCount();
                        _totalReturning += __GetReturningCount();
                    }
                    
                    ++_i;
                }
                
                if (ImGui.BeginTable("Pool Table", 6, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg))
                {
                    ImGui.TableSetupColumn("Name");
                    ImGui.TableSetupColumn("Size");
                    ImGui.TableSetupColumn("Active");
                    ImGui.TableSetupColumn("Inactive");
                    ImGui.TableSetupColumn("(Pooled)");
                    ImGui.TableSetupColumn("(Returning)");
                    
                    ImGui.TableHeadersRow();
                    
                    ImGui.TableNextRow();
                    ImGui.TableNextColumn();
                    ImGui.Text("Total Sum");
                    ImGui.TableNextColumn();
                    ImGui.Text(_totalSize);
                    ImGui.TableNextColumn();
                    ImGui.Text(_totalActive);
                    ImGui.TableNextColumn();
                    ImGui.Text(_totalInactive);
                    ImGui.TableNextColumn();
                    ImGui.Text(_totalPooled);
                    ImGui.TableNextColumn();
                    ImGui.Text(_totalReturning);
                    
                    var _i = 0;
                    repeat(array_length(_poolArray))
                    {
                        with(_poolArray[_i])
                        {
                            ImGui.TableNextRow();
                            ImGui.TableNextColumn();
                            ImGui.Text(_poolNameArray[_i]);
                            ImGui.TableNextColumn();
                            ImGui.Text(__GetSize());
                            ImGui.TableNextColumn();
                            ImGui.Text(__GetActiveCount());
                            ImGui.TableNextColumn();
                            ImGui.Text(__GetInactiveCount());
                            ImGui.TableNextColumn();
                            ImGui.Text(__GetPooledCount());
                            ImGui.TableNextColumn();
                            ImGui.Text(__GetReturningCount());
                        }
                        
                        ++_i;
                    }
                    
                    ImGui.EndTable();
                }
                
                ImGui.EndTabItem();
            }
            
            ImGui.EndTabBar();
        }
    }
            
    ImGui.End();
}