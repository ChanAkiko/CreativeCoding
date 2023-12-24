ArrayList<Particle> particles; // 粒子列表
int maxHistorySize = 50; // 轨迹的最大长度

void setup() {
  size(800, 600);
  colorMode(HSB, 360, 100, 100, 100);
  particles = new ArrayList<Particle>();
  for (int i = 0; i < 600; i++) {
    particles.add(new Particle(random(width), random(height)));
  }
}

void draw() {
  fill(0, 0, 100, 10);
  noStroke();
  rect(0, 0, width, height);

  for (Particle p : particles) {
    p.run(particles);
  }
}

class Particle {
  PVector position; // 粒子位置
  PVector velocity; // 粒子速度
  PVector acceleration; // 粒子加速度
  float r; // 交互半径
  float mass; // 粒子质量
  float diameter; // 粒子直径，影响显示大小
  float maxForce = 0.05; // 最大转向力
  float maxSpeed = 2; // 最大速度
  int particleHue = 230; // 粒子的色相
  int s; // 粒子的饱和度
  int b; // 粒子的亮度
  //ArrayList<PVector> history; // 存储粒子的历史位置

  Particle(float x, float y) {
    position = new PVector(x, y);
    velocity = PVector.random2D();
    acceleration = new PVector(0, 0);
    mass = random(0.5, 3);
    diameter = mass * 5;
    r = diameter * 0.5f;
    particleHue = 180; // 选择一个固定的色相值
    s = (int)random(100); // 随机饱和度
    b = (int)random(100); // 随机亮度
  }

  void run(ArrayList<Particle> particles) {
    flock(particles);
    update();
    borders();
    display();
  }

  void applyForce(PVector force) {
    PVector f = force.copy();
    f.div(mass); // 受力等于质量除以加速度
    acceleration.add(f);
  }


  void flock(ArrayList<Particle> particles) {
    PVector sep = separate(particles); // 分离
    PVector coh = cohere(particles); // 凝聚
    // 权衡这些力以模拟群体行为
    sep.mult(1.5);
    coh.mult(1.0);
    applyForce(sep);
    applyForce(coh);
  }

  // 更新粒子位置
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    position.add(velocity);
  }

  // 计算与其他粒子的分离
  PVector separate(ArrayList<Particle> particles) {
    PVector steer = new PVector(0, 0);
    int count = 0;
    for (Particle other : particles) {
      float d = PVector.dist(position, other.position);
      float buffer = r + other.r; // 合并半径
      if ((d > 0) && (d < buffer)) { // 检查粒子是否相交而不是仅比较中心点
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d); // 越近影响越大
        steer.add(diff);
        count++;
      }
    }
    if (count > 0) {
      steer.div((float)count);
    }
    if (steer.mag() > 0) {
      steer.normalize();
      steer.mult(maxSpeed);
      steer.sub(velocity);
      steer.limit(maxForce);
    }
    return steer;
  }

  // 计算与其他粒子的凝聚
  PVector cohere(ArrayList<Particle> particles) {
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Particle other : particles) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < r)) {
        sum.add(other.position);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      return seek(sum);
    } else {
      return new PVector(0, 0);
    }
  }

  // 朝向目标
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);
    desired.normalize();
    desired.mult(4);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(0.1);
    return steer;
  }

  // 处理边界
  void borders() {
    if (position.x < -r) {
      position.x = width + r;

    }
    if (position.y < -r) {
      position.y = height + r;

    }
    if (position.x > width + r) {
      position.x = -r;

    }
    if (position.y > height + r) {
      position.y = -r;

    }
  }

  // 显示粒子
  void display() {
    // 绘制粒子（圆形）
    noStroke();
    fill(particleHue, s, b);
    ellipse(position.x, position.y, diameter, diameter);
  }
}
