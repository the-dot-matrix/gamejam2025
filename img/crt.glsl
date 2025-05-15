const float OX = 1.0/1600;
const float OY = 1.0/1200;
const int P = 3;
const int B = 1;
const float D = 2;
vec4 effect(vec4 color, Image tex, vec2 txy, vec2 sxy) {
  int mx = int(mod(sxy.x, P));
  int my = int(mod(sxy.y, P));
  float b = (mod(floor(sxy.x/P),2) * P) - (P/2.0);
  int sx = (mx==0) ? 0 : (mx==2) ? 1 : -1;
  int sy = (my==0) ? 0 : (my==2) ? 1 : -1;
  int d = int(abs(sx)+abs(sy));
  vec2 srcxy = vec2(txy.x+(sx*OX), txy.y+((sy+b)*OY));
  vec4 src = Texel(tex, srcxy);
  vec4 avg = vec4(0);
  for (int y = -B; y <= B; y+=1) {
    for (int x = -B; x <= B; x+=1) {
      vec2 oxy = vec2(srcxy.x+(x*OX),srcxy.y+((sy+b)*OY));
      avg += Texel(tex, oxy);
    }
  }
  avg = vec4(avg.xyz/pow(B*2+1,2), avg.w);
  float M = 0;
  M += max(src.x,src.y);
  M += max(src.y,src.z);
  M += max(src.z,src.x);
  M /= P;
  vec4 bleed = vec4(avg.xyz/pow(D,d*(1.1-M)),avg.w);
  vec4 rgb = vec4(M,M,M,1);
  rgb[int(mod(sxy.x,P))] = 1;
  return (mx==0 && my==0) ? src : rgb*bleed;
}
