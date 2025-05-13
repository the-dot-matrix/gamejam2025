const float offsetx = 1.0/800;
const float offsety = 1.0/600;
vec4 effect(vec4 color, Image tex, vec2 txy, vec2 sxy) {
  int mx = int(mod(sxy.x, 3));
  int my = int(mod(sxy.y, 3));
  int d = mx+my;
  int sx = (mx==0) ? 0 : (mx==2) ? 1 : -1;
  int sy = (my==0) ? 0 : (my==2) ? 1 : -1;
  vec2 srcxy = vec2(txy.x+(sx*offsetx), txy.y+(sy*offsety));
  vec4 src = Texel(tex, srcxy);
  vec4 avg = vec4(0);
  for (int y = -2; y <= 2; y+=1) {
    for (int x = -2; x <= 2; x+=1) {
      vec2 oxy = vec2(srcxy.x+(x*offsetx),srcxy.y+(y*offsety));
      avg += Texel(tex, oxy);
    }
  }
  avg = vec4(avg.xyz/25, avg.w);
  vec3 M = ((src.xyz)/3)-0.5;
  vec4 bleed = vec4(avg.xyz/d, avg.w);
  bleed = vec4((avg.xyz+M+0.5)/(1+d-((M+1)*d)), avg.w);
  vec4 rgb = bleed;
  rgb[int(mod(sxy.x*sxy.y,3))] = max(max(rgb.x,rgb.y),rgb.z)*2;
  return (mx==0 && my==0) ? src : rgb;
}
