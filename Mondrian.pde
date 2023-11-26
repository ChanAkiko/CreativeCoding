int[] colors;  // 颜色数组
ArrayList<Float> verticalLinesList;  // 储存垂直线的位置列表
ArrayList<Float> horizontalLinesList;  // 储存水平线的位置列表
int minBlockSize = 50;  // 最小的块大小，避免太小的块

void setup() {
  size(640, 640);
  noLoop();
  strokeWeight(6);  
  // 配色风格：Christmas
  colors = new int[] {color(248, 190, 17), color(194, 17, 17), color(23, 130, 59), color(49, 49, 115)};
  // 初始化线条位置列表
  verticalLinesList = null;
  horizontalLinesList = null;
}

void draw() {
  if (verticalLinesList == null || horizontalLinesList == null) {
    // 生成线条位置列表
    verticalLinesList = generateLines(width);
    horizontalLinesList = generateLines(height);
  }
  
  // 绘制作品
  drawMondrian();
  saveFrame();
}

void drawMondrian() {
  background(255);
  rectMode(CORNERS);

  // 画垂直线
  for (Float x : verticalLinesList) {
    line(x, 0, x, height);
  }
  
  // 画水平线
  for (Float y : horizontalLinesList) {
    line(0, y, width, y);
  }
  
  // 填充色块
  for (int i = 0; i < verticalLinesList.size() - 1; i++) {
    for (int j = 0; j < horizontalLinesList.size() - 1; j++) {
      // 随机决定是否填充颜色
      if (random(1) < 0.5) {
        int c = colors[(int)random(colors.length)];
        fill(c);
        rect(verticalLinesList.get(i), horizontalLinesList.get(j), verticalLinesList.get(i + 1), horizontalLinesList.get(j + 1));
      }
    }
  }
}

// 当鼠标点击时重新生成线条并重新绘制
void mouseClicked() {
  verticalLinesList = generateLines(width);
  horizontalLinesList = generateLines(height);
  redraw(); 
  saveFrame();
}

// 生成线条位置的函数
ArrayList<Float> generateLines(int maxPosition) {
  ArrayList<Float> lines = new ArrayList<Float>();
  lines.add(0.0);  // 边界线
  while (true) {
    float nextLine = lines.get(lines.size() - 1) + minBlockSize + random(maxPosition / 5);
    if (nextLine >= maxPosition - minBlockSize) {
      break;
    }
    lines.add(nextLine);
  }
  lines.add((float)maxPosition);  // 边界线
  return lines;
}
