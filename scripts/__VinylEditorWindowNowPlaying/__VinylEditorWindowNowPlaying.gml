// Feather disable all

function __VinylEditorWindowNowPlaying(_stateStruct)
{
    static _globalData    = __VinylGlobalData();
    static _topLevelArray = _globalData.__topLevelArray;
    
    static _editor = __VinylGlobalData().__editor;
    if (not VinylEditorIsShowing()) return;
    
    ImGui.SetNextWindowSize(room_width/2, room_height/2, ImGuiCond.Once);
    ImGui.SetNextWindowPos(room_width/4, room_height/4, ImGuiCond.Once);
	
    var ret = ImGui.Begin("Now Playing", __VinylEditorWindowGetOpen("__nowPlaying"), undefined, ImGuiReturnMask.Both);
    __VinylEditorWindowSetOpen("__nowPlaying", (ret & ImGuiReturnMask.Pointer));
    
    if (ret & ImGuiReturnMask.Return)
    {
    	if (ImGui.BeginTabBar("Now Playing Tab Bar"))
        {
            if (ImGui.BeginTabItem("Voices"))
            {
                ImGui.Text("Total playing: " + string(array_length(_topLevelArray)));
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
                    //Set up our columns with fixed widths so we get a nice pretty layout
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