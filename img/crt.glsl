const float OX = 1.0/1600;
const float OY = 1.0/1200;
const int P = 3;
const int B = 1;
const float D = 2;
const int S = 1;
vec4 effect(vec4 color, Image tex, vec2 txy, vec2 sxy) {
  int x = int(sxy.x)/S;
  int y = int(sxy.y)/S;
  int mx = int(mod(x, P*S));
  float b = mod(floor(x/P),2)*(P*S/2.0);
  int my = int(mod(y+b,P*S));
  int sx = (int(mx/S)==2) ? 1 : (int(mx/S)==1) ? -1 : 0;
  int sy = (int(my/S)==2) ? 1 : (int(my/S)==1) ? -1 : 0;
  float d = abs(sy); // TODO incorporate S
  vec2 srcxy = vec2(txy.x+(sx*OX), txy.y+(sy*OY));
  vec4 src = Texel(tex, srcxy);
  vec4 avg = vec4(0);
  for (int y = -B; y <= B; y+=1) {
    for (int x = -B; x <= B; x+=1) {
      vec2 oxy = vec2(srcxy.x+(x*OX),srcxy.y+(y*OY));
      avg += Texel(tex, oxy);
    }
  }
  avg = vec4(avg.xyz/pow(B*2+1,2), avg.w);
  float M = 0;
  M += max(src.x,src.y);
  M += max(src.y,src.z);
  M += max(src.z,src.x);
  M /= 3;
  vec4 bleed = vec4(avg.xyz/pow(D,d*(1.1-M)),avg.w);
  vec4 rgb = vec4(M,M,M,1);
  rgb[int(mod(x,P))] = 1;
  return (mx==0 && my==0) ? rgb*bleed : rgb*bleed;
}
