const float offsetx = 1/266;
const float offsety = 1/200;
vec4 effect(vec4 color, Image tex, vec2 txy, vec2 sxy) {
  int mx = int(mod(sxy.x, 3));
  int my = int(mod(sxy.y, 3));
  int xx = (mx==0) ? 0 : (mx==2) ? 1 : -1;
  int yy = (my==0) ? 0 : (my==2) ? 1 : -1;
  int d = mx+my;
  vec2 mxy = vec2(txy.x+(xx*offsetx), txy.y+(yy*offsety));
  vec4 avg = vec4(0);
  for (int y = -my; y <= my; y+=1) {
    for (int x = -mx; x <= mx; x+=1) {
      vec2 oxy = vec2(mxy.x+(x*offsetx), mxy.y+(y*offsety));
      avg += Texel(tex, oxy);
    }
  }
  avg = vec4(avg.xyz/(((2*mx)+1)*((2*my)+1)), avg.w);
  float M = ((avg.x+avg.y+avg.z)/3)-0.5;
  vec4 bleed = vec4((avg.xyz+M+0.5)/(1+d-((M+0.5)*d)), avg.w);
  return (mx==0 && my==0) ? color * avg : color * bleed;
}
