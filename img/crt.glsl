const float offsetx = 1/266;
const float offsety = 1/200;
vec4 effect(vec4 color, Image tex, vec2 txy, vec2 sxy) {
  int mx = int(mod(sxy.x, 3));
  int my = int(mod(sxy.y, 3));
  int xx = (mx==2) ? 1 : -1;
  int yy = (my==2) ? 1 : -1;
  int d = mx+my;
  vec2 mxy = vec2(txy.x+(xx*offsetx), txy.y+(yy*offsety));
  vec4 average = vec4(0);
  for (int y = -1; y <= 1; y+=1) {
    for (int x = -1; x <= 1; x+=1) {
      vec2 oxy = vec2(mxy.x+(x*offsetx), mxy.y+(y*offsety));
      average += Texel(tex, oxy);
    }
  }
  average = average / 3;
  return (mx==0 && my==0) ? average : (average/(d+1));
}
