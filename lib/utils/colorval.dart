part of dockable_utils;

num inRange(num value, num min, num max) {
  num up_r = value == null ? min : value;
  if (up_r < min) {
    up_r = min;
  } else if (up_r > max) {
    up_r = max;
  }

  return up_r;
}


/*
 * ColorVal represents RGB color values. It provides convinience methods to
 * parse and encode in different color formats.
 */
@observable
class ColorVal extends ChangeNotifier {
  /** Red color component. Value ranges from [0..255] */
  num _r = 255;

  @observable
  num get r => _r;
  set r(num new_r) {
    num up_r = inRange(new_r, 0, 255);
    _r = notifyPropertyChange(#r, _r, up_r);

    notifyPropertyChange(#h, null, h);
    notifyPropertyChange(#s, null, s);
    notifyPropertyChange(#v, null, v);

    notifyPropertyChange(#rgbaString, "", rgbaString);
  }

  /** Green color component. Value ranges from [0..255] */
  num _g = 255;
  @observable
  num get g => _g;
  set g(num new_g) {
    num up_g = inRange(new_g, 0, 255);
    _g = notifyPropertyChange(#g, _g, up_g);

    notifyPropertyChange(#h, -1, h);
    notifyPropertyChange(#s, -1, s);
    notifyPropertyChange(#v, -1, v);

    notifyPropertyChange(#rgbaString, "", rgbaString);
  }

  /** Blue color component. Value ranges from [0..255] */
  num _b = 255;
  @observable
  num get b => _b;
  set b(num new_b) {
    num up_b = inRange(new_b, 0, 255);
    _b = notifyPropertyChange(#b, _b, up_b);

    notifyPropertyChange(#h, null, h);
    notifyPropertyChange(#s, null, s);
    notifyPropertyChange(#v, null, v);

    notifyPropertyChange(#rgbaString, "", rgbaString);
  }

  /** Alpha color component. Value ranges from [0..100] */
  num _a = 100;
  @observable
  num get a => _a;
  set a(num new_a) {
    num up_a = inRange(new_a, 0, 100);
    _a = notifyPropertyChange(#a, _a, up_a);

    notifyPropertyChange(#rgbaString, "", rgbaString);
  }

  /**
   * Parses the color value with the following format:
   *    "#fff"
   *    "#ffffff"
   *    "255, 255, 255"
   *    "rgb(255, 255, 255)"
   *    "rgba(255, 255, 255, 1.0)"
   */
  ColorVal.from(String value) {
    value.trim();
    if (value.startsWith("#")) {
      // Remove the #
      value = value.substring(1);
      _parseHex(value);
    } else if (value.contains(",")) {
      if (value.startsWith("rgb(")) {
        value = value.substring(4, value.length - 1);
      } else if (value.startsWith("rgba(")) {
        value = value.substring(5, value.length - 1);
      }
      List<String> tokens = value.split(",");
      if (tokens.length < 3) {
        throw new Exception("Invalid color value format");
      }
      r = int.parse(tokens[0]);
      g = int.parse(tokens[1]);
      b = int.parse(tokens[2]);

      if (tokens.length > 3) {
        a = num.parse(tokens[3]) * 100;
      } else {
        a = 100;
      }
    }
  }

  ColorVal() {
    r = g = b = 255;
    a = 100;
  }

  ColorVal.fromRGB(num new_red, num new_green, num new_blue) {
    r = new_red;
    g = new_green;
    b = new_blue;
  }

  ColorVal.fromRGBA(num new_red, num new_green, num new_blue, num new_alpha) {
    r = new_red;
    g = new_green;
    b = new_blue;
    a = new_alpha;
  }

  ColorVal.fromHSV(num hue, num saturation, num value) {
    setHSV(hue, saturation, value);
  }

  ColorVal.copy(ColorVal other) {
    clone(other);
  }

  void clone(ColorVal other) {
    this.r = other.r;
    this.g = other.g;
    this.b = other.b;
    this.a = other.a;
  }

  void setRGB(num r, num g, num b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }
  void setRGBA(num r, num g, num b, num a) {
    this.r = r;
    this.g = g;
    this.b = b;
    this.a = a;
  }

  void setHSV(num arg_hue, num saturation, num value) {
    num t_r;
    num t_g;
    num t_b;

    arg_hue = arg_hue % (360);
    if (arg_hue < 0) {
      arg_hue = 360 - arg_hue;
    }

    num t_hue = arg_hue / 60;
    int i_i = t_hue.floor();
    num i_f = t_hue - i_i;

    num i_l = (value * ((100 - saturation))) / 100;
    num i_m = (value * (100 - (saturation * i_f))) / 100;
    num i_n = (value * (100 - ((1 - i_f) * saturation))) / 100;

    num val = value;

    switch (i_i) {
      case 0:
        t_r = val;
        t_g = i_n;
        t_b = i_l;
        break;
      case 1:
        t_r = i_m;
        t_g = val;
        t_b = i_l;
        break;
      case 2:
        t_r = i_l;
        t_g = val;
        t_b = i_n;
        break;
      case 3:
        t_r = i_l;
        t_g = i_m;
        t_b = val;
        break;
      case 4:
        t_r = i_n;
        t_g = i_l;
        t_b = val;
        break;
      case 5:
        t_r = val;
        t_g = i_l;
        t_b = i_m;
        break;
    }
    r = t_r * 100 / 255;
    g = t_g * 100 / 255;
    b = t_b * 100 / 255;
  }

  /**
   * Parses the color value in the format FFFFFF or FFF
   * and is not case-sensitive
   */
  void _parseHex(String hex) {
    if (hex.length != 3 && hex.length != 6) {
      throw new Exception("Invalid color hex format");
    }

    if (hex.length == 3) {
      var a = hex.substring(0, 1);
      var b = hex.substring(1, 2);
      var c = hex.substring(2, 3);
      hex = "$a$a$b$b$c$c";
    }
    var hexR = hex.substring(0, 2);
    var hexG = hex.substring(2, 4);
    var hexB = hex.substring(4, 6);
    r = int.parse("0x$hexR");
    g = int.parse("0x$hexG");
    b = int.parse("0x$hexB");
  }

  ColorVal operator *(num value) {
    return new ColorVal.fromRGB(r * value, g * value, b * value);
  }
  ColorVal operator +(ColorVal other) {
    return new ColorVal.fromRGB(r + other.r, g + other.g, b + other.b);
  }

  ColorVal operator -(ColorVal other) {
    return new ColorVal.fromRGB((r - other.r).abs(), (g - other.g).abs(), (b - other.b).abs());
  }

  String toString() => rgbaString;
  String toRgbString() => "$r, $g, $b";

  String get rgbaString => "rgba(${r.toInt()}, ${g.toInt()}, ${b.toInt()}, ${a / 100.0})";

  //y'uv
  num get luma {
    return (0.3 * r + 0.59 * g + 0.11 * b) / 255;
  }

  /*num get cb {
    //TODO:
  }

  num get cr {
    //TODO:
  }*/

  //hsv
  num get h {
    num ret;

    final maxV = max(max(r, g), b);
    final minV = min(min(r, g), b);
    final range = maxV - minV;

    if (maxV == minV) {
      ret = 0;
    } else if (r == maxV) {
      ret = (((g - b) / range) * 60);
    } else if (g == maxV) {
      ret = ((2 + (b - r) / range) * 60);
    } else if (b == maxV) {
      ret = ((4 + (r - g) / range) * 60);
    }

    ret = ret % 360;
    if (ret < 0) {
      ret = 360 + ret;
    }

    return ret;
  }

  set h(num new_h) {
    num saturation = s;
    num value = v;

    setHSV(new_h, saturation, value);
  }

  num get s {
    final maxV = max(max(r, g), b);
    final minV = min(min(r, g), b);
    final range = maxV - minV;

    if (maxV == 0) {
      return 0;
    } else {
      return (range * 100) ~/ maxV;
    }
  }

  set s(num new_s) {
    num hue = h;
    num value = v;

    setHSV(hue, new_s, value);
  }

  num get v {
    return max(max(r, g), b) * 100 / 255;
  }

  set v(num new_v) {
    num hue = h;
    num saturation = s;

    setHSV(hue, saturation, new_v);
  }
}
