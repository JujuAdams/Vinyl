var _string = "";
_string += "Vinyl " + __VINYL_VERSION + ", " + __VINYL_DATE + "\n";
_string += "Library by @jujuadams, music \"Chicken Nuggets\" by @WangleLine\n";
_string += "\n";
_string += "Total playing = " + string(VinylSystemPlayingCountGet()) + "\n";

draw_text(10, 10, _string);