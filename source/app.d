import std.stdio;
import Dgame.Window.Window;
import Dgame.Window.Event;
import Dgame.System.Keyboard;
import Dgame.System.StopWatch;

enum MAP_WIDTH = 24; 	/** Constant width for the map. */
enum MAP_HEIGHT = 24;	/** Constant height for the map.*/

/**
	Map represented by a twodimensional array.
	Each number represents a wall inside the map explained
	in the list bellow.

	0: No wall, empty space.
	1: Wall
	2: Wall
	3: Wall
	4: Wall
	5: Wall
*/
int [MAP_WIDTH][MAP_HEIGHT] worldMap = [
    [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,2,2,2,2,2,0,0,0,0,3,0,3,0,3,0,0,0,1],
    [1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,3,0,0,0,3,0,0,0,1],
    [1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,2,2,0,2,2,0,0,0,0,3,0,3,0,3,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,4,4,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,4,0,4,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,4,0,0,0,0,5,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,4,0,4,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,4,0,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,4,4,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
];

bool running = true;
Window wnd;

// Position vector
double posX = 22;
double posY = 12;

// Direction vector.
double dirX = -1;
double dirY = 0;

// 2D Raycaster camera plane.
double planeX = 0;
double planeY = 0.66;

void main() {

    wnd = Window(800, 600, "Raycaster");

    update();
}

void update() {
    Event event;
    while (running) {
        wnd.clear();

        while (wnd.poll(&event)) {
            switch (event.type) {
                case Event.Type.Quit:
                    writeln("Quit Event");
                    running = false;
                break;

                case Event.Type.KeyDown:
                    writeln("Pressed Key ", event.keyboard.key);

                    if (event.keyboard.key == Keyboard.Key.Esc) {
                        running = false;
                    }
                break;

                default : break;
            }
        }

        // Raycasting
        for (int x = 0; x < 800; x++) {
            double cameraX = 2 * 800 / 800 - 1;
            double rayPosX = posX;
            double rayPosY = posY;
            double rayDirX = dirX + planeX + cameraX;
            double rayDirY = dirY + planeY + cameraX;
        }

        wnd.display();
    }
}