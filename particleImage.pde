boolean canShowCircles = true;
boolean isAnimating = false;
int duration = 100;
int animatingTime = 0;
ArrayList<Circle> circles;
PImage img;

void setup() {
  size(400, 600);
  circles = new ArrayList<Circle>();
  img = loadImage("R.jpg");
  imageMode(CENTER);
  img.resize(width, height);
}

void draw() {
  translate(width / 2, height / 2);
  background(0);
  // 遍历并显示所有圆圈
  for (Circle c : circles) {
    c.display();
  }
  //控制动画时长
  if (isAnimating) {
    animatingTime++;
    if (animatingTime == duration) {
      isAnimating = false;
      canShowCircles = !canShowCircles;
    }
  }
  saveFrame();
}

void mousePressed() {
  // 当鼠标被按下时创建圆圈
  makeCircles();
  isAnimating = true;
  animatingTime = 0;
}

void makeCircles() {
  // 初始化圆圈ArrayList
  circles = new ArrayList<Circle>();
  // 随机创建大量圆圈
  for (int i = 0; i < 20000; i++) {
    // 随机生成圆圈位置和半径
    PVector loc = new PVector(random(-width/2, width/2), random(-height/2, height/2));
    float radius = random(2, 15);
    // 检查新圆圈是否与已有圆圈重叠
    boolean isOverlapped = false;
    for (Circle other : circles) {
      if (PVector.dist(loc, other.loc) < radius + other.radius) {
        isOverlapped = true;
        continue;
      }
    }
    // 如果没有重叠，则添加到圆圈ArrayList中
    if (!isOverlapped) {
      circles.add(new Circle(loc, radius));
    }
  }
   saveFrame();
}


class Circle {
  PVector loc;
  float radius;
  color c;

  // 构造函数，初始化圆圈位置和半径
  Circle(PVector _loc, float _radius) {
    loc = _loc;
    radius = _radius;
  }

  // 显示圆圈的方法
  void display() {
    // 计算圆圈中心的屏幕坐标
    int x = (int)loc.x;
    int y = (int)loc.y;
    // 获取图像上对应点的颜色
    color pix = img.get(x+img.width/2, y+img.height/2);
    // 设置填充颜色为图像对应颜色
    fill(pix);
    noStroke();
    float r;
    if (isAnimating && canShowCircles) {
      r = map(pow(float(animatingTime) / duration, 1.0 / 4), 0, 1, 0, radius);
    } else if (isAnimating && !canShowCircles) {
      r = map(1.0 - pow(float(animatingTime) / duration, 1.0 / 4), 0, 1, 0, radius);
    } else if (!canShowCircles) {
      r = radius;
    } else {
      r = 0;
    }
    ellipse(loc.x, loc.y, r * 2, r * 2);
  }
}
