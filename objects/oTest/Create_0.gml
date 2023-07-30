if (__VINYL_CONFIG_NOTE_NAME != "TestConfig")
{
    __VinylError("This test object requires __VINYL_CONFIG_NOTE_NAME to be set to \"TestConfig\"");
}

music = undefined;

VinylSystemGainSet(0.5);
show_debug_overlay(true);
VinylGuiShowAsset("music sync test");