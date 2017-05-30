module raycaster;

import std.conv;
import std.math;

import Dgame.Window.Window;
import Dgame.Graphic;
import Dgame.Math;

import camera;
import worldmap;

class RayCaster {

    private static immutable int SCREEN_WIDTH = 512;
    private static immutable int SCREEN_HEIGHT = 384;

    public static void castRay(ref Window wnd, ref Camera cam) {
        // Raycasting
        for (int x = 0; x < this.SCREEN_WIDTH; x++) {
            // Calculate ray position and direction.
            double cameraX = 2.0 * x / this.SCREEN_WIDTH - 1.0;
            double rayPosX = cam.pos.x;
            double rayPosY = cam.pos.y;
            double rayDirX = cam.dir.x + cam.plane.x * cameraX;
            double rayDirY = cam.dir.y + cam.plane.y * cameraX;

            // Which box of the map is the position vector currently in.
            int mapX = to!int(rayPosX);
            int mapY = to!int(rayPosY);

            // Length of the rat from current pos to next x or y-side.
            double sideDistX;
            double sideDistY;

            // Length of ray from one x or y-side to next x or y-side.
            double deltaDistX = sqrt(1.0 + (rayDirY * rayDirY) / (rayDirX * rayDirX));
            double deltaDistY = sqrt(1.0 + (rayDirX * rayDirX) / (rayDirY * rayDirY));
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
                if (WorldMap.isWall(mapX, mapY)) {
                    hit = 1;
                }
            }

            // Calculate distance projected on camera direction
            // (oblique distance will give fisheye effect!)
            if (side == 0) {
                perpWallDist = abs((mapX - rayPosX + (1.0 - stepX) / 2.0) / rayDirX);
            }
            else {
                perpWallDist = abs((mapY - rayPosY + (1.0 - stepY) / 2.0) / rayDirY);
            }

            // Calculate height of the line to draw on screen.
            int lineHeight = to!int(this.SCREEN_HEIGHT / perpWallDist);

            // Calculate lowest and highest pixel to fill in current stripe
            int drawStart = to!int((-lineHeight) / 2.0 + this.SCREEN_HEIGHT / 2.0);
            if(drawStart < 0) {
                drawStart = 0;
            }

            int drawEnd = to!int(lineHeight / 2.0 + this.SCREEN_HEIGHT / 2.0);
            if(drawEnd >= this.SCREEN_HEIGHT) {
                drawEnd = this.SCREEN_HEIGHT - 1;
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

            switch (WorldMap.getWall(mapX, mapY)) {
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
    }
}
