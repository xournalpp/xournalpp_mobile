import 'dart:math';
import 'dart:ui';

List<Offset> circleIntersection(
    {Offset a, Offset b, Offset circle, double radius}) {
  // compute the euclidean distance between A and B
  double lengthAtoB = sqrt(pow((b.dx - a.dx), 2) + pow((b.dy - a.dy), 2));

// compute the direction vector D from A to B
  Offset d = Offset((b.dx - a.dx) / lengthAtoB, (b.dy - a.dy) / lengthAtoB);

// the equation of the line AB is x = d.dx*t + a.dx, y = d.dy*t + a.dy with 0 <= t <= LAB.

// compute the distance between the points A and E, where
// E is the point of AB closest the circle center (circle.dx, circle.dy)
  double t = d.dx * (circle.dx - a.dx) + d.dy * (circle.dy - a.dy);

// compute the coordinates of the point E
  Offset e = Offset(t * d.dx + a.dx, t * d.dy + a.dy);

// compute the euclidean distance between E and C
  double lengthEtoC =
      sqrt(pow((e.dx - circle.dx), 2) + pow((e.dy - circle.dy), 2));

// test if the line intersects the circle
  if (lengthEtoC < radius) {
    // compute distance from t to circle intersection point
    double dt = sqrt(pow(radius, 2) - pow(lengthEtoC, 2));

    // compute first and second intersection point
    return ([
      Offset((t - dt) * d.dx + a.dx, (t - dt) * d.dy + a.dy),
      Offset((t + dt) * d.dx + a.dx, (t + dt) * d.dy + a.dy)
    ]);
  } else {
    return ([]);
  }
}
