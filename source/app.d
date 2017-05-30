import std.stdio;
import std.conv;
import std.math;

import Dgame.Window.Window;
import Dgame.Window.Event;
import DgameKeyboard = Dgame.System.Keyboard;
import Dgame.Graphic;
import Dgame.Math;
import Dgame.System.StopWatch;

import minimap;
import keyboard;
import worldmap;
import vector2d;
import camera;
import raycaster;

enum SCREEN_WIDTH = 512;
enum SCREEN_HEIGHT = 384;

immutable ubyte FPS = 30;
immutable ubyte TICKS_PER_FRAME = 1000 / FPS;
StopWatch sw;

bool running = true;
Window wnd;
Camera cam;

void main() {
    cam = new Camera();

    wnd = Window(512, 384, "Raycaster");
    wnd.setClearColor(Color4b.Black);
    wnd.setVerticalSync(Window.VerticalSync.Enable);

    update();
}

void input(Event event) {
    // Handle keypresses.
    while (wnd.poll(&event)) {
        Keyboard.handleKeypress(event, cam, running); 
    }
}

void update() {
    Event event;
    while (running) {
        wnd.clear();

        input(event);


        // Handle raycasting.
        RayCaster.castRay(wnd, cam);
        
        render();
    }
}

void render() {
    wnd.display();
}
