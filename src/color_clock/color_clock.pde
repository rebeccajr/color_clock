/***************************************************************
 Created by:    Rebecca

 Description:   This program maps the current time to a color.
 
                Time is displayed as a colored ellipse.
                color will cycle through "main colors" i.e.
                red, yellow, green, cyan, blue, and magenta
                with the following RGB values:
                
                red     0xFF0000
                yellow  0xFF0000
                green   0x00FF00 
                cyan    0x00FFFF
                blue    0x0000FF
                magenta 0xFF00FF
                
***************************************************************/


/********************************
future development

remove globals!!
user selection of main colors
number of main colors
color of main colors

********************************/

int r, g, b;
int sec_since_midnight;

int second_color;

// set constants
int MAX_VAL    = 255;
int MIN_VAL    = 0;
int SEC_IN_MIN = 60;
int MIN_IN_HR  = 60;
int SEC_IN_HR  = SEC_IN_MIN * MIN_IN_HR;


int [] main_color_times;
boolean time_interval;

float hours_since_midnight, fractional_offset_from_color, hours_bet_colors;
int normalized_offset;


void setup(){

    // housekeeping
    size(300, 300);
    background(0);
    colorMode(RGB, MAX_VAL, MAX_VAL, MAX_VAL);
    ellipseMode(RADIUS);
    frameRate(50);
    
    // hours_bet_colors: hours between each of 6 colors
    hours_bet_colors = 4;
    
    // array of times 
    main_color_times = initialize_color_times(hours_bet_colors);

    print("------------------------\n");
    
}

void draw(){
  ellipse(150, 150, 100, 50);

  // returns current time as an offset from the last major color
  get_time_as_normalized_offset(hours_bet_colors);
  
  // time interval: boolean noting that time is moving in direction of
  //                even or odd color
  //
  // false => moving towards primary color (red, green, blue)
  // true  => moving towards secondary color (yellow, cyan, magenta)
  time_interval = (int(hours_since_midnight) % (hours_bet_colors * 2))  < (hours_bet_colors);
  
  print("\nint hours_since_midnight: ", int(hours_since_midnight), "\n");
 
 
  // make general purpose interpolation function
  
  // array of main colors
  // array of time for each color?
  // given current time, and above arrays
  
  
  
  
  // nested interpolate function to get rgb between two colors
  // <r1,g1,b1>,<r2,g2,b2>, % return rgb - color object


  // !time_interval => moving towards R, G, B
  if (!time_interval) {
    second_color = MAX_VAL - normalized_offset;
    if (second_color < MIN_VAL) {
      second_color = MIN_VAL;
    }
  }
  
  // time_interval => moving towards yellow, cyan, magenta
  else {
    second_color = normalized_offset;
    if (normalized_offset < MIN_VAL) second_color = MIN_VAL;
  }
  

  
  if (hours_since_midnight >= main_color_times[6]) hours_since_midnight = 0;
  
  if (hours_since_midnight >= main_color_times[0] && hours_since_midnight <= main_color_times[1]) {
    r = MAX_VAL;
    b = MIN_VAL;
    g = second_color;
    print("red to yellow\n");
  }
  
  if (hours_since_midnight >= main_color_times[1] && hours_since_midnight <= main_color_times[2]) {
    r = second_color;
    b = MIN_VAL;
    g = MAX_VAL;
    print("yellow to green\n");
  }
  
  if (hours_since_midnight >= main_color_times[2] && hours_since_midnight <= main_color_times[3]) {
    g = MAX_VAL;
    r = MIN_VAL;
    b = second_color;
    print("green to cyan\n");
  }  
 
  if (hours_since_midnight >= main_color_times[3] && hours_since_midnight <= main_color_times[4]) {
    g = second_color;
    b = MAX_VAL;
    r = MIN_VAL;
    print("cyan to blue\n");
  }
 
  if (hours_since_midnight >= main_color_times[4] && hours_since_midnight <= main_color_times[5]) {
    b = MAX_VAL;
    g = MIN_VAL;
    r = second_color;
    print("blue to magenta\n");
  }
  
  if (hours_since_midnight >= main_color_times[5] && hours_since_midnight <= main_color_times[6]) {
    b = second_color;
    g = MIN_VAL;
    r = MAX_VAL;
    print("magenta to red\n");
  }
  
  debug_msg();
  
  //set_colors();
  
  fill(r, g, b);
  noStroke();
    
}

// depending on time, sets RGB values
// not written yet
int[] set_colors() {
  int [] rgb;
  rgb = new int[3];
  
  rgb[0] = 1;
  rgb[1] = 2;
  rgb[2] = 3;
  
  //print("\n", rgb[0], rgb[1], rgb[2]);
  return rgb;
  
}



// returns offset from last main color, normalized to 255
int get_time_as_normalized_offset(float hours_bet_colors) {

  sec_since_midnight   = (SEC_IN_MIN * (hour() * MIN_IN_HR + minute()) + second());
  hours_since_midnight = (sec_since_midnight/(1.0 * SEC_IN_HR));

  // offset from bin - normalized as a fraction of bin size (hours between colors)
  fractional_offset_from_color = (hours_since_midnight % hours_bet_colors)/hours_bet_colors;
  
  // offset from bin normalized to MAX_VAL
  normalized_offset = int(fractional_offset_from_color * MAX_VAL);
  
  return normalized_offset;

}

int convert_hr_to_sec_since_midnight(float hrs_since_midnight){
  return (int) (1.0 * SEC_IN_HR * hrs_since_midnight); 
}



// initialize array that stores times of main colors
int [] initialize_color_times(float hours_between_colors) {

  int [] color_times = new int[7];
  for (int i = 0; i < 7; i++) {
    color_times[i] = i * int(hours_between_colors);
    print("color_times: ", i, "---->", color_times[i], "\n");
  }
  
  return color_times;
}

// initialize array that contains main colors 
// currently hard-coded
int [] initialize_main_colors(){
  
  int [] colors = new int[6];
  
  colors[0] = 0xFF0000; // red
  colors[1] = 0xFFFF00; // yellow
  colors[2] = 0x00FF00; // green
  colors[3] = 0x00FFFF; // cyan
  colors[4] = 0x0000FF; // blue
  colors[5] = 0xFF00FF; // magenta
  
  return colors;
}

// prints values valuable for debugging
void debug_msg() {
  print("hour = ", hour(), "\n");  
  print("hours_since_midnight = ", hours_since_midnight, ", ", "fractional_offset_from_color = ", fractional_offset_from_color, ", normalized_offset = ", normalized_offset, ", ");
  print ("time_interval = ", time_interval, "\n");
  
  print("second_color = ", second_color, "; \n");
  print("r = ", r, ", g = ", g, ", b = ", b, ";\n");
  print("------------------------\n");
}
