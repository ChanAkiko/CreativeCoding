// 树的基本参数
float branchAngle; 
float branchLength = 150;
int maxDepth = 10;

void setup() {
  size(800, 600);
  smooth();
}

void draw() {
  background(255);

  // 计算基于鼠标位置的分支角度
  branchAngle = map(mouseX, 0, width, 0, PI/4); // 调整为PI/4产生锐角

  // 画树，树的根位于画布底部中心
  strokeWeight(10); // 设置初始枝干的粗细
  drawBranch(width/2, height, branchLength, -HALF_PI, 0);
  saveFrame();
}

void drawBranch(float x, float y, float len, float angle, int depth) {
  // 设置子分支的不透明度，随着深度增加而降低
  int alpha = int(map(depth, 0, maxDepth, 255, 10));
  stroke(0, 0, 0, alpha);

  // 设置分支的粗细，随着深度增加而减少
  strokeWeight(map(depth, 0, maxDepth, 10, 1));

  // 计算新分支的末端位置
  float x2 = x + len * cos(angle);
  float y2 = y + len * sin(angle);

  // 画线表示分支
  line(x, y, x2, y2);

  // 如果没有达到最大深度，递归地画更多的分支
  if (depth < maxDepth) {
    float newLength = len * 0.67; // 每一层分支长度减少
    drawBranch(x2, y2, newLength, angle + branchAngle, depth + 1);
    drawBranch(x2, y2, newLength, angle - branchAngle, depth + 1);
  } 
}

// 当鼠标点击时，重置树的深度
void mousePressed() {
  maxDepth = maxDepth >= 15 ? 1 : maxDepth + 1;
}
