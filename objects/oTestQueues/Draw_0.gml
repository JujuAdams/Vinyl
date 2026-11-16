draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIButtonNewline("<-- Back to main menu", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestMainMenu);
});
UINewline();
UIButton("Play", function()
{
    VinylStop(voice);
    voice = VinylPlay(queue);
});
UINewline();
UIButton("Stop current", function()
{
    VinylStop(voice);
});
UISpace(20);
UIButton("Fade out current", function()
{
    VinylFadeOut(voice, 1);
});
UISpace(20);
UIText(VinylGetPlaying(voice)? $"Behavior = {voice.GetBehavior()}" : "<no queue playing>");
UINewline();
UIButton("DONT_LOOP (0)", function()
{
    voice.SetBehavior(VINYL_QUEUE_DONT_LOOP);
});
UISpace(20);
UIButton("LOOP_EACH (1)", function()
{
    voice.SetBehavior(VINYL_QUEUE_LOOP_EACH);
});
UISpace(20);
UIButton("LOOP_ON_LAST (2)", function()
{
    voice.SetBehavior(VINYL_QUEUE_LOOP_ON_LAST);
});
UINewline();
UIButton("Play queue once", function()
{
    VinylSetLoop(voice, false);
});
UISpace(10);
UIButton("Loop queue", function()
{
    VinylSetLoop(voice, true);
});
UINewline();
UINewline();
UIButton("Set 0", function()
{
    VinylFadeOut(voice, 1);
    voice.SetBottom(sndSync0);
});
UISpace(20);
UIButton("Set 1", function()
{
    VinylFadeOut(voice, 1);
    voice.SetBottom(sndSync1);
});
UISpace(20);
UIButton("Set 2", function()
{
    VinylFadeOut(voice, 1);
    voice.SetBottom(sndSync2);
});
UISpace(20);
UIButton("Set 3", function()
{
    VinylFadeOut(voice, 1);
    voice.SetBottom(sndSync3);
});
UISpace(20);
UIButton("Set 1KHz", function()
{
    VinylFadeOut(voice, 1);
    voice.SetBottom(snd1KHz);
});
UINewline();
UIButton("Push 0", function()
{
    voice.PushBottom(sndSync0);
});
UISpace(20);
UIButton("Push 1", function()
{
    voice.PushBottom(sndSync1);
});
UISpace(20);
UIButton("Push 2", function()
{
    voice.PushBottom(sndSync2);
});
UISpace(20);
UIButton("Push 3", function()
{
    voice.PushBottom(sndSync3);
});
UISpace(20);
UIButton("Push 1KHz", function()
{
    voice.PushBottom(snd1KHz);
});
UINewline();
UINewline();
var _asset = VinylGetAsset(voice);
UIText(audio_exists(_asset)? audio_get_name(_asset) : "<no queue playing>");
UISpace(20);
UIText(VinylGetLoop(voice)? "(looping queue)" : "(playing queue once)");
UINewline();
UITextNewline(VinylGetPlaying(voice)? json_stringify(voice.GetPlayableArray(), true) : "<no queue playing>");