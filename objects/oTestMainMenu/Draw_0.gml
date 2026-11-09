draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UITextInline(string_concat("Vinyl ", VINYL_VERSION, ", ", VINYL_DATE, " by Juju Adams\nChicken Nuggets by Wangle Line"));
UINewline();
UIButton("Basic Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestBasic);
});
UIButton("Mix Groups Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestMixGroups);
});
UIButton("BPM Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestBPM);
});



//UIButton("Queue Test", function()
//{
//    instance_destroy();
//    instance_create_layer(0, 0, "Instances", oTestQueues);
//});
//UIButton("Effects Test", function()
//{
//    instance_destroy();
//    instance_create_layer(0, 0, "Instances", oTestEffects);
//});
//UIButton("Abstract Test", function()
//{
//    instance_destroy();
//    instance_create_layer(0, 0, "Instances", oTestAbstract);
//});
//UIButton("PlayAt Test", function()
//{
//    instance_destroy();
//    instance_create_layer(0, 0, "Instances", oTestPlayAt);
//});
//UIButton("External Test", function()
//{
//    instance_destroy();
//    instance_create_layer(0, 0, "Instances", oTestExternal);
//});
//UIButton("Ducker Test", function()
//{
//    instance_destroy();
//    instance_create_layer(0, 0, "Instances", oTestDucker);
//});