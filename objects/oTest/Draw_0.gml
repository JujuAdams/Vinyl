var _distance = point_distance(mouse_x, mouse_y, room_width/2, room_height/2);

var _string = "";
_string += "Vinyl " + __VINYL_VERSION + ", " + __VINYL_DATE + "\n";
_string += "Library by @jujuadams, music \"Chicken Nuggets\" by @WangleLine\n";
_string += "\n";
_string += "Total playing = " + string(VinylSystemPlayingCountGet()) + "\n";
_string += "\n";
_string += "distance = " + string(_distance) + "\n";
_string += "\n";
_string += "\n";
_string += "\n";
_string += "\n";
_string += "\n";

draw_text(10, 10, _string);

if (is_struct(emitter)) emitter.DebugDraw();