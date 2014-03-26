part of dockable_utils;

/*
 * TODO: add alpha channel support
 */

/*
 * ColorVal represents RGB color values. It provides convinience methods to
 * parse and encode in different color formats.
 */
class ColorVal extends Observable {
  /** Red color component. Value ranges from [0..255] */
  @observable
  int r;

  /** Green color component. Value ranges from [0..255] */
  @observable
  int g;

  /** Blue color component. Value ranges from [0..255] */
  @observable
  int b;

  /**
   * Parses the color value with the following format:
   *    "#fff"
   *    "#ffffff"
   *    "255, 255, 255"
   */
  ColorVal.from(String value) {
    if (value.startsWith("#")) {
      // Remove the #
      value = value.substring(1);
      _parseHex(value);
    } else if (value.contains(",")) {
      List<String> tokens = value.split(",");
      if (tokens.length < 3) {
        throw new Exception("Invalid color value format");
      }
      r = int.parse(tokens[0]);
      g = int.parse(tokens[1]);
      b = int.parse(tokens[2]);
      r = max(0, min(255, r));
      g = max(0, min(255, g));
      b = max(0, min(255, b));
    }
  }

  ColorVal()
      : r = 0,
        g = 0,
        b = 0;
  ColorVal.fromRGB(this.r, this.g, this.b);
  ColorVal.fromHSV(int hue, num saturation, num value) {
    setHSV(hue, saturation, value);
  }
  ColorVal.copy(ColorVal other) {
    clone(other);
  }

  void setRGB(int r, int g, int b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }
  void setHSV(int arg_hue, num saturation, num value) {
    num t_r;
    num t_g;
    num t_b;

    arg_hue = arg_hue % (360);
    if(arg_hue < 0) {
      arg_hue = 360 - arg_hue;
    }

    num t_hue = arg_hue / 60;
    int i_i = t_hue.floor();
    num i_f = t_hue - i_i;
    num i_l = value * (1 - saturation);
    num i_m = value * (1 - (saturation * i_f));
    num i_n = value * (1 - ((1 - i_f) * saturation));

    switch (i_i) {
      case 0:
        t_r = value; t_g= i_n; t_b = i_l;
        break;
      case 1:
        t_r = i_m; t_g = value; t_b = i_l;
        break;
      case 2:
        t_r = i_l; t_g = value; t_b = i_n;
        break;
      case 3:
        t_r = i_l; t_g = i_m; t_b = value;
        break;
      case 4:
        t_r = i_n; t_g = i_l; t_b = value;
        break;
      case 5:
        t_r = value; t_g = i_l; t_b = i_m;
        break;
    }
    r = (t_r * 255).toInt();
    g = (t_g * 255).toInt();
    b = (t_b * 255).toInt();
  }
  void clone(ColorVal other) {
    this.r = other.r;
    this.g = other.g;
    this.b = other.b;
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
    return new ColorVal.fromRGB((r * value).toInt(), (g * value).toInt(), (b *
        value).toInt());
  }
  ColorVal operator +(ColorVal other) {
    return new ColorVal.fromRGB(r + other.r, g + other.g, b + other.b);
  }

  ColorVal operator -(ColorVal other) {
    return new ColorVal.fromRGB(r - other.r, g - other.g, b - other.b);
  }

  String toString() => "rgba($r, $g, $b, 1.0)";
  String toRgbString() => "$r, $g, $b";

  //y'uv
  num get luma {
    return (0.3 * r + 0.59 * g + 0.11 * b) / 255;
  }

  num get cb {

  }

  num get cr {

  }

  //hsv
  int get h {
    int ret;
    final num i_r = r / 255;
    final num i_g = g / 255;
    final num i_b = b / 255;

    // Calculate the hue (H) component in the HSV color space
    /*final num alpha = (2 * i_r - i_g - i_b) / 2;
    final num beta = sqrt(3) / 2 * (i_g - i_b);
    num hue = atan2(beta, alpha);
    if (hue < 0) {
      hue += PI * 2;
    }
    return hue;*/

    num cmax = max(max(i_r, i_g), i_b);
    num cmin = min(min(i_r, i_g), i_b);

    if (cmax == cmin)
      ret = 0;
    else if (i_r == cmax)
      ret = (((i_g - i_b) / (cmax - cmin)) * 60).toInt();
    else if (i_g == cmax)
      ret = ((2 + (i_b - i_r) / (cmax - cmin)) * 60).toInt();
    else if (i_b == cmax)
      ret = ((4 + (i_r - i_g) / (cmax - cmin)) * 60).toInt();

    ret = ret % 360;
    if(ret < 0) {
      ret = 360 + ret;
    }

    //ret = (ret / 180) * PI;

    return ret;
  }

  num get s {
    final num i_r = r / 255;
    final num i_g = g / 255;
    final num i_b = b / 255;

    /*final alpha = (2 * i_r - i_g - i_b) / 2;
    final beta = sqrt(3) / 2 * (i_g - i_b);

    num chroma = sqrt(alpha * alpha + beta * beta);

    // Get the saturation (S) component
    return (chroma == 0) ? 0 : chroma / v;*/



    num cmax = max(max(i_r, i_g), i_b);
    num cmin = min(min(i_r, i_g), i_b);

    if (cmax == cmin) return 0; else return (cmax - cmin) / cmax;
  }

  num get v {
    return (max(max(r, g), b)) / 255;
  }
}

/* Some helper functions for @ColorVal */
ColorVal hueAngleToColorVal(int angle) {
  var slots = [new ColorVal.fromRGB(255, 0, 0), new ColorVal.fromRGB(255, 255, 0
      ), new ColorVal.fromRGB(0, 255, 0), new ColorVal.fromRGB(0, 255, 255),
      new ColorVal.fromRGB(0, 0, 255), new ColorVal.fromRGB(255, 0, 255)];

  // Each slot is 60 degrees.  Find out which slot this angle lies in
  // http://en.wikipedia.org/wiki/Hue
  int degrees = angle % 360;
  final slotPosition = degrees / 60;
  final slotIndex = slotPosition.toInt();
  final slotDelta = slotPosition - slotIndex;
  final startColor = slots[slotIndex];
  final endColor = slots[(slotIndex + 1) % slots.length];
  return startColor + (endColor - startColor) * slotDelta;
}
