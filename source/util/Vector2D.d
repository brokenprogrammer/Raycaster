module vector2d;

import std.math;

struct Vector2D {
    double x;
    double y;

    void rotate(double rotationAmmount) {
       double oldx = x;
       x = x * cos(rotationAmmount) - y * sin(rotationAmmount);
       y = oldx * sin(rotationAmmount) + y * cos(rotationAmmount);
    }
}
