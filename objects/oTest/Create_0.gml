hltVoice   = undefined;
blendVoice = undefined;

show_debug_message(json_stringify(VinylSetupExportJSON(), true));
show_debug_message(VinylSetupExportGMLMacros());
show_debug_message(VinylSetupExportGML(true));