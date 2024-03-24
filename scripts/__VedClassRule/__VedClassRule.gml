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
        if (ImGui.Button("Add Filter"))
        {
            var _filter = new __VedClassRuleFilter();
            _filter.__opened = true;
            array_push(__filterArray, _filter);
        }
        
        ImGui.BeginChild("Filter Panel", undefined, ImGui.GetContentRegionAvailY()/2, ImGuiChildFlags.Border, ImGuiWindowFlags.AlwaysVerticalScrollbar);
        
        var _i = 0;
        repeat(array_length(__filterArray))
        {
            ImGui.ArrowButton("Up", ImGuiDir.Up);
            ImGui.SameLine();
            ImGui.ArrowButton("Down", ImGuiDir.Down);
            ImGui.SameLine();
            __filterArray[_i].__BuildUI(_i);
            ++_i;
        }
        
        ImGui.EndChild();
        ImGui.NewLine();
        
        if (ImGui.Button("Add Action"))
        {
            array_push(__filterArray, new __VedClassRuleAction());
        }
        
        ImGui.BeginChild("Action Panel", undefined, ImGui.GetContentRegionAvailY(), ImGuiChildFlags.Border, ImGuiWindowFlags.AlwaysVerticalScrollbar);
        
        var _i = 0;
        repeat(array_length(__actionArray))
        {
            __actionArray[_i].__BuildUI(_i);
            ++_i;
        }
        
        ImGui.EndChild();
    }
}