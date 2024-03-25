// Feather disable all

function __VedClassRule() constructor
{
    __name        = undefined;
    __filterArray = [];
    __actionArray = [];
    
    static __Serialize = function(_array)
    {
        var _filterArray = [];
        var _i = 0;
        repeat(array_length(__filterArray))
        {
            __filterArray[_i].__Serialize(_filterArray);
            ++_i;
        }
        
        var _actionArray = [];
        var _i = 0;
        repeat(array_length(__actionArray))
        {
            __actionArray[_i].__Serialize(_actionArray);
            ++_i;
        }
        
        array_push(_array, {
            name:        __name,
            filterArray: _filterArray,
            actionArray: _actionArray,
        });
    }
    
    static __Deserialize = function(_data)
    {
        __name        = _data.name;
        __filterArray = [];
        __actionArray = [];
        
        var _filterArrayIn = _data[$ "filterArray"];
        if (is_array(_filterArrayIn))
        {
            var _i = 0;
            repeat(array_length(_filterArrayIn))
            {
                var _filter = new __VedClassRuleFilter();
                _filter.__Deserialize(_filterArrayIn[_i]);
                array_push(__filterArray, _filter);
                ++_i;
            }
        }
        
        var _actionArrayIn = _data[$ "actionArray"];
        if (is_array(_actionArrayIn))
        {
            var _i = 0;
            repeat(array_length(_actionArrayIn))
            {
                var _action = new __VedClassRuleAction();
                _action.__Deserialize(_actionArrayIn[_i]);
                array_push(__actionArray, _action);
                ++_i;
            }
        }
    }
    
    static __BuildUI = function()
    {
        if (ImGui.BeginTabBar("Rules Tab Bar"))
        {
            if (ImGui.BeginTabItem("Filters"))
            {
                if (ImGui.Button("Add Filter"))
                {
                    var _filter = new __VedClassRuleFilter();
                    _filter.__opened = true;
                    array_push(__filterArray, _filter);
                }
        
                ImGui.BeginChild("Filter Panel", undefined, undefined, ImGuiChildFlags.Border, ImGuiWindowFlags.AlwaysVerticalScrollbar);
        
                if (ImGui.BeginTable("Filter Table", 3))
                {
                    ImGui.TableSetupColumn("", ImGuiTableColumnFlags.WidthFixed, 22);
                    ImGui.TableSetupColumn("", ImGuiTableColumnFlags.WidthFixed, 24);
                    ImGui.TableSetupColumn("", ImGuiTableColumnFlags.WidthStretch, 1);
                    
                    var _length = array_length(__filterArray);
                    var _i = 0;
                    repeat(array_length(__filterArray))
                    {
                        ImGui.TableNextRow();
                        ImGui.TableSetColumnIndex(0);
                        
                        ImGui.BeginDisabled(_i <= 0);
                        if (ImGui.ArrowButton("Up " + string(_i), ImGuiDir.Up))
                        {
                            var _temp = __filterArray[_i];
                            __filterArray[_i] = __filterArray[_i-1];
                            __filterArray[_i-1] = _temp;
                        }
                        ImGui.EndDisabled();
                        
                        ImGui.TableSetColumnIndex(1);
                        
                        ImGui.BeginDisabled(_i >= _length-1);
                        if (ImGui.ArrowButton("Down " + string(_i), ImGuiDir.Down))
                        {
                            var _temp = __filterArray[_i];
                            __filterArray[_i] = __filterArray[_i+1];
                            __filterArray[_i+1] = _temp;
                        }
                        ImGui.EndDisabled();
                        
                        ImGui.TableSetColumnIndex(2);
                        
                        var _return = ImGui.CollapsingHeader("##" + string(_i), true, ImGuiTreeNodeFlags.DefaultOpen, ImGuiReturnMask.Both);
                        if (not (_return & ImGuiReturnMask.Pointer))
                        {
                            array_delete(__filterArray, _i, 1);
                        }
                        else
                        {
                            if (_return & ImGuiReturnMask.Return)
                            {
                                __filterArray[_i].__BuildUI();
                            }
                            
                            ++_i;
                        }
                    }
                    
                    ImGui.EndTable();
                }
        
                ImGui.EndChild();
                ImGui.EndTabItem();
            }
                
            if (ImGui.BeginTabItem("Actions"))
            {
                if (ImGui.Button("Add Action"))
                {
                    array_push(__filterArray, new __VedClassRuleAction());
                }
        
                ImGui.BeginChild("Action Panel", undefined, undefined, ImGuiChildFlags.Border, ImGuiWindowFlags.AlwaysVerticalScrollbar);
        
                var _i = 0;
                repeat(array_length(__actionArray))
                {
                    __actionArray[_i].__BuildUI(_i);
                    ++_i;
                }
        
                ImGui.EndChild();
                ImGui.EndTabItem();
            }
        }
    }
}