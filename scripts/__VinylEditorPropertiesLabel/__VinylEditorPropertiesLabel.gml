// Feather disable all

function __VinylEditorPropertiesLabel(_contentDict, _contentName, _selectionHandler)
{
    //For easier reading, all the widgets are handled by parsing this array!
    static _displayWidgetArray = [
        { __name: "Gain",         __function: __VinylEditorPropWidgetGain,        },
        { __name: "Pitch",        __function: __VinylEditorPropWidgetPitch,       },
        { __name: "Loop",         __function: __VinylEditorPropWidgetLoop,        },
        { __name: "Stack",        __function: __VinylEditorPropWidgetStack,       },
        { __name: "Effect Chain", __function: __VinylEditorPropWidgetEffectChain, },
        { __name: "Persistent",   __function: __VinylEditorPropWidgetPersistent,  },
        { __name: "Transpose",    __function: __VinylEditorPropWidgetTranspose,   },
    ];
    
    var _contentData = _contentDict[$ _contentName];
    var _parentData  = _contentDict[$ _contentData.__parent];
    
    //Now do the actual table
    if (ImGui.BeginTable("Vinyl Properties", 3, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 280))
    {
        //Set up our columns with fixed widths so we get a nice pretty layout
        ImGui.TableSetupColumn("Name",   ImGuiTableColumnFlags.WidthFixed, 100);
        ImGui.TableSetupColumn("Option", ImGuiTableColumnFlags.WidthFixed, 125);
        ImGui.TableSetupColumn("Value",  ImGuiTableColumnFlags.WidthStretch, 1);
        
        //Make aaaall the widgets
        var _i = 0;
        repeat(array_length(_displayWidgetArray))
        {
            var _displayWidget = _displayWidgetArray[_i];
            _displayWidget.__function(_contentName, _contentData, _parentData, 0, 2, 1);
            ++_i;
        }
        
        ImGui.EndTable();
    }
}