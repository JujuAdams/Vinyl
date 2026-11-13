draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIText(string_concat("Vinyl ", VINYL_VERSION, ", ", VINYL_DATE, " by Juju Adams\nChicken Nuggets by Wangle Line"));
UINewline();
UIButton("Basic Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestBasic);
});
UINewline();
UIButton("Mix Groups Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestMixGroups);
});
UINewline();
UIButton("BPM Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestBPM);
});
UINewline();
UIButton("Queue Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestQueues);
});
UINewline();
UIButton("HLT Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestHLT);
});
UINewline();
UIButton("Random & Shuffle Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestRandomAndShuffle);
});
UINewline();
UIButton("Exclusive & Limit Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestExclusiveAndLimit);
});
UINewline();
UIButton("Retrigger Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestRetrigger);
});
UINewline();

//UIButton("Effects Test", function()
//{
//    instance_destroy();
//    instance_create_layer(0, 0, "Instances", oTestEffects);
//});
//UINewline();
//UIButton("PlayAt Test", function()
//{
//    instance_destroy();
//    instance_create_layer(0, 0, "Instances", oTestPlayAt);
//});
//UINewline();
//UIButton("External Test", function()
//{
//    instance_destroy();
//    instance_create_layer(0, 0, "Instances", oTestExternal);
//});
//UINewline();
//UIButton("Ducker Test", function()
//{
//    instance_destroy();
//    instance_create_layer(0, 0, "Instances", oTestDucker);
//});