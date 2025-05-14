const float offsetx = 1.0/800;
const float offsety = 1.0/600;
vec4 effect(vec4 color, Image tex, vec2 txy, vec2 sxy) {
  int mx = int(mod(sxy.x, 3));
  int my = int(mod(sxy.y+mod(floor(sxy.x/3),2), 3));
  int sx = (mx==0) ? 0 : (mx==2) ? 1 : -1;
  int sy = (my==0) ? 0 : (my==2) ? 1 : -1;
  int d = int(abs(sx)+abs(sy));
  vec2 srcxy = vec2(txy.x+(sx*offsetx), txy.y+(sy*offsety));
  vec4 src = Texel(tex, srcxy);
  vec4 avg = vec4(0);
  for (int y = -1; y <= 1; y+=1) {
    for (int x = -1; x <= 1; x+=1) {
      vec2 oxy = vec2(srcxy.x+(x*offsetx),srcxy.y+(y*offsety));
      avg += Texel(tex, oxy);
    }
  }
  avg = vec4(avg.xyz/9, avg.w);
  float M = 0;
  M += max(src.x,src.y);
  M += max(src.y,src.z);
  M += max(src.z,src.x);
  M /= 3;
  vec4 bleed = vec4(avg.xyz/pow(2,d*(1-M)),avg.w);
  vec4 rgb = vec4(M,M,M,1);
  rgb[int(mod(sxy.x,3))] = 1;
  return (mx==0 && my==0) ? src : rgb*bleed;
}
