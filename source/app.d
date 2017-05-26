import std.stdio;
import std.conv;
import std.math;
import Dgame.Window.Window;
import Dgame.Window.Event;
import Dgame.System.Keyboard;
import Dgame.Graphic;
import Dgame.Math;
import Dgame.System.StopWatch;

enum MAP_WIDTH = 24; 	/** Constant width for the map. */
enum MAP_HEIGHT = 24;	/** Constant height for the map.*/

enum SCREEN_WIDTH = 512;
enum SCREEN_HEIGHT = 384;

immutable ubyte FPS = 30;
immutable ubyte TICKS_PER_FRAME = 1000 / FPS;
StopWatch sw;

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
    [1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2],
    [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
    [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,2,2,2,2,2,0,0,0,0,3,0,3,0,3,0,0,0,2],
    [2,0,0,0,0,0,2,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,3,0,0,0,3,0,0,0,2],
    [2,0,0,0,0,0,2,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,2,2,0,2,2,0,0,0,0,3,0,3,0,3,0,0,0,2],
    [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
    [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
    [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
    [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,4,4,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
    [2,4,0,4,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,4,0,0,0,0,5,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
    [2,4,0,4,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,4,0,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
    [2,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,4,4,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
    [2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1]
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

//speed modifiers
double moveSpeed = 0.5; //the constant value is in squares/second
double rotSpeed = 0.03; //the constant value is in radians/second

void main() {

    wnd = Window(512, 384, "Raycaster");
    wnd.setClearColor(Color4b.Black);
    wnd.setVerticalSync(Window.VerticalSync.Enable);

    update();
}

void input() {

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

                    if (event.keyboard.key == Keyboard.Key.W) {
                        if(worldMap[to!int(posX + dirX * moveSpeed)][to!int(posY)] == false) posX += dirX * moveSpeed;
                        if(worldMap[to!int(posX)][to!int(posY + dirY * moveSpeed)] == false) posY += dirY * moveSpeed;
                    }

                    if (event.keyboard.key == Keyboard.Key.A) {
                        //both camera direction and camera plane must be rotated
                        double oldDirX = dirX;
                        dirX = dirX * cos(rotSpeed) - dirY * sin(rotSpeed);
                        dirY = oldDirX * sin(rotSpeed) + dirY * cos(rotSpeed);
                        double oldPlaneX = planeX;
                        planeX = planeX * cos(rotSpeed) - planeY * sin(rotSpeed);
                        planeY = oldPlaneX * sin(rotSpeed) + planeY * cos(rotSpeed);
                    }

                    if (event.keyboard.key == Keyboard.Key.D) {
                        //both camera direction and camera plane must be rotated
                        double oldDirX = dirX;
                        dirX = dirX * cos(-rotSpeed) - dirY * sin(-rotSpeed);
                        dirY = oldDirX * sin(-rotSpeed) + dirY * cos(-rotSpeed);
                        double oldPlaneX = planeX;
                        planeX = planeX * cos(-rotSpeed) - planeY * sin(-rotSpeed);
                        planeY = oldPlaneX * sin(-rotSpeed) + planeY * cos(-rotSpeed);
                    }

                break;

                default : break;
            }
        }

        // Raycasting
        for (int x = 0; x < SCREEN_WIDTH; x++) {
            // Calculate ray position and direction.
            double cameraX = 2 * SCREEN_WIDTH / SCREEN_WIDTH - 1;
            double rayPosX = posX;
            double rayPosY = posY;
            double rayDirX = dirX + planeX + cameraX;
            double rayDirY = dirY + planeY + cameraX;

            // Which box of the map is the position vector currently in.
            int mapX = to!int(rayPosX);
            int mapY = to!int(rayPosY);

            // Length of the rat from current pos to next x or y-side.
            double sideDistX;
            double sideDistY;

            // Length of ray from one x or y-side to next x or y-side.
            double deltaDistX = sqrt(1 + (rayDirY * rayDirY) / (rayDirX * rayDirX));
            double deltaDistY = sqrt(1 + (rayDirX * rayDirX) / (rayDirY * rayDirY));
            double perpWallDist;

            // What side to step in x or y-direction (Either +1 or -1)
            int stepX;
            int stepY;

            int hit = 0; // Was a wall hit
            int side; // Was a NS or a EW wall hit

            // Calculate step and initial sideDist
            if (rayDirX < 0) {
                stepX = -1;
                sideDistX = (rayPosX - mapX) * deltaDistX;
            } else {
                stepX = 1;
                sideDistX = (mapX + 1.0 - rayPosX) * deltaDistX;
            }

            if (rayDirY < 0) {
                stepY = -1;
                sideDistY = (rayPosY - mapY) * deltaDistY;
            } else {
                stepY = 1;
                sideDistY = (mapY + 1.0 - rayPosY) * deltaDistY;
            }

            // Perform DDA algorithm
            while (hit == 0) {
                // Jump to the next map square, OR in x-direction, OR in y-direction.
                if (sideDistX < sideDistY) {
                    sideDistX += deltaDistX;
                    mapX += stepX;
                    side = 0;
                }
                else {
                    sideDistY += deltaDistY;
                    mapY += stepY;
                    side = 1;
                }

                //Check if ray has hit a wall
                if (worldMap[mapX][mapY] > 0) hit = 1;
            }

            // Calculate distance projected on camera direction
            // (oblique distance will give fisheye effect!)
            if (side == 0) {
                perpWallDist = (mapX - rayPosX + (1 - stepX) / 2) / rayDirX;
            }
            else {
                perpWallDist = (mapY - rayPosY + (1 - stepY) / 2) / rayDirY;
            }

            // Calculate height of the line to draw on screen.
            int lineHeight = to!int(SCREEN_HEIGHT / perpWallDist);

            // Calculate lowest and highest pixel to fill in current stripe
            int drawStart = to!int(-lineHeight / 2 + SCREEN_HEIGHT / 2);
            if(drawStart < 0) {
                drawStart = 0;
            }

            int drawEnd = to!int(lineHeight / 2 + SCREEN_HEIGHT / 2);
            if(drawEnd >= SCREEN_HEIGHT) {
                drawEnd = SCREEN_HEIGHT - 1;
            }


            //give x and y sides different brightness
            //if (side == 1) {
            //    color = color / 2;
            //}

            Shape vLine = new Shape(Geometry.Lines,
            [
                Vertex(x, drawStart),
                Vertex(x, drawEnd)
            ]);

            switch (worldMap[mapX][mapY]) {
                case 1:
                    vLine.setColor(Color4b.Red);
                break;
                case 2:
                    vLine.setColor(Color4b.Green);
                break;
                case 3:
                    vLine.setColor(Color4b.White);
                break;
                case 4:
                    vLine.setColor(Color4b.Blue);
                break;

                default:
                    vLine.setColor(Color4b.Yellow);
                break;
            }

            //draw the pixels of the stripe as a vertical line
            //verLine(x, drawStart, drawEnd, color);

            vLine.fill = Shape.Fill.Full;
            //vLine.setColor(Color4b.Blue);
            wnd.draw(vLine);            
        }

        Shape v = new Shape(Geometry.Lines,
        [
            Vertex(10, 10),
            Vertex(10, SCREEN_HEIGHT)
        ]);
        v.setColor(Color4b.Yellow);
        wnd.draw(v);

        wnd.display();
    }
}

void render() {

}