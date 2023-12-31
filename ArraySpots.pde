//借鉴了Examples里面的Array2D，并增加了一些新功能
//*新增了 点的亮度变化跟随鼠标移动
//*新增了 点击按钮随机改变点的间距和大小
//*新增了 鼠标滚轮控制色相变化

import controlP5.*;
ControlP5 cp5;
PFont font;
float[][] distances;  //二维数组，用于存储每个点到鼠标的距离
float maxDistance;  //画布对角线距离
int spacer;  //点的间距
int hue = 0;  


void setup() {
  size(1280, 720);
  spacer = 5;
  strokeWeight(3);  //笔刷大小，即点的大小
  colorMode(HSB,255);  //设置色彩模式
  
  
  cp5 = new ControlP5(this);  //创建ControlP5 对象 cp5
  font = createFont("Yahei Consolas Hybrid", 15);  //设置字体
  //创建按钮
  cp5.addButton("changeSpacer")
     .setPosition(20, 20)
     .setSize(120, 30)
     .getCaptionLabel().setFont(font).toUpperCase(false);
     
  cp5.addButton("changeSize")
     .setPosition(20, 70)
     .setSize(120, 30)
     .getCaptionLabel().setFont(font).toUpperCase(false);
}


void draw() {
  background(0);
  maxDistance = dist(0, 0, width, height); 
  distances = new float[width][height];
   //计算每个点到鼠标的距离
  for (int y = 0; y< height; y++) {
    for (int x = 0; x <width; x++) {
      float distance = dist(mouseX, mouseY, x, y);
      distances[x][y] = distance/maxDistance *255;  //距离归一化到 0-255 的范围内，可以直接用于设置颜色
    }
  }
  
  //画点阵列
  for (int y = 0; y < height; y += spacer) {
    for (int x = 0; x < width; x += spacer) {
      stroke(hue,distances[x][y],255);  //明度取决于点到鼠标的距离
      point(x + spacer/2, y + spacer/2);
    }
  }
}


//用鼠标滚轮控制色相
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  hue += e*10;
  hue = hue % 255;
  if(hue < 0){
    hue += 255;
  }
}


//点击按钮随机改变点的间距和大小
public void changeSpacer() {
  spacer = int(random(10, 31));
}

public void changeSize() {
  strokeWeight(random(3, 21));
}
