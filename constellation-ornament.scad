
$fa = $preview ? 6 : 0.2;
$fs = $preview ? 1 : 0.2;

globe_diam = 35;
star_diam = 0.7;

module ball() {
	difference() {
		sphere(d=globe_diam);
		sphere(d=(globe_diam-4));
	}
}


use </home/berocs/documents/3d-printing/vbas/projector/utils.scad>
use </home/berocs/PycharmProjects/hip_parser/constellations.scad>


//
// star = [alpha, delta]
//
module uMA() {
	s_67301 = [206.88560880, 49.31330288];
	s_65378 = [200.98091604, 54.92541525];
	s_62956 = [193.50680410, 55.95984301];
	s_59774 = [183.85603795, 57.03259792];
	s_54061 = [165.93265365, 61.75111888];
	s_53910 = [165.45996150, 56.38234478];
	s_58001 = [178.45725536, 53.69473296];
	s_57399 = [176.51305887, 47.77933701];
	s_54539 = [167.41608092, 44.49855337];
	s_50372 = [154.27469564, 42.91446855];
	s_50801 = [155.58251355, 41.49943350];
	s_48402 = [148.02650069, 54.06428574];
	s_46853 = [143.21802191, 51.67860208];
	s_44471 = [135.90649494, 47.15665934];
	s_44127 = [134.80349479, 48.04234956];
	s_48319 = [147.74871542, 59.03910437];
	s_41704 = [127.56679232, 60.71843110];
	s_46733 = [142.88154025, 63.06179545];

	line(s_67301, s_65378);
	line(s_65378, s_62956);
	line(s_62956, s_59774);
	line(s_59774, s_54061);
	line(s_54061, s_53910);
	line(s_53910, s_58001);
	line(s_58001, s_59774);
	line(s_58001, s_57399);
	line(s_57399, s_54539);
	line(s_54539, s_50372);
	line(s_54539, s_50801);
	line(s_53910, s_48402);
	line(s_48402, s_46853);
	line(s_46853, s_44471);
	line(s_46853, s_44127);
	line(s_48402, s_48319);
	line(s_48319, s_41704);
	line(s_41704, s_46733);
	line(s_46733, s_54061);
	
//	star(s_67301);
//	star(s_65378);
//	star(s_62956);
//	star(s_59774);
//	star(s_54061);
//	star(s_53910);
//	star(s_58001);
//	star(s_57399);
//	star(s_54539);
//	star(s_50372);
//	star(s_50801);
//	star(s_48402);
//	star(s_46853);
//	star(s_44471);
//	star(s_44127);
//	star(s_48319);
//	star(s_41704);
//	star(s_46733);
}

module assembly() {
	difference() {
		ball();
//		translate([0, 0, 13.8]) {
//			linear_extrude(4) {
//				text("0.60", size=4, halign="center", valign="center");
//			}
//		}
		ch = 1;
		for(i = [0:9]) {
			rotate([0, 25 + (i*15), 0]) {
				translate([0, 0, ch/2 + diam/2 - 1])
					cylinder(h = ch, d1 = 0, d2 = (1 - (i/10)), center = true);
			}
//			rotate([90, 0, 180 + (i*15)]) {
//				translate([0, 0, ch/2 + diam/2 - 1])
//					cylinder(h = ch, d = (1 - (i/10)), center = true);
//			}
		}
	}
}

module test() {
	union() {
		ball();
		uMA();
	}
}


module projector() {
	difference() {
		ball();
		all_constellations_lines(globe_diam, star_diam);
	}
}


module projector_with_mount() {
	depth = (globe_diam/2) + 0.2;
	difference() {
		//%ball(); 
		projector();
		union() {
			translate([0, 0, -depth])
				cylinder(h = depth, d = 4.1);
			translate([0, 0, 0])
				cylinder(h = 2, d = 6);
			translate([0, 0, 2])
				cylinder(h=3, d2=0, d1=6);
			translate([0, 0, -0.5])
				cylinder(h=0.5, d2=6, d1=4);
			translate([0, 0, -depth])
				cylinder(h=1, d2=4, d1=6);
		}
	}
}

module axial_tilt() {
	rotate([23.44, 0, 0]) {
		children();
	}
}

module ornament() {
	axle_len = 6;
	cyl_h = axle_len/2-0.02;
	axle_diam = 3.5;
	tolerance = 0.5; // Gap between axle and socket

	union() {
		// Globe itself
		union() {
			projector();
			for(i = [0:1]) {
				rotate([i*180, 0, 0]) {
					translate([0, 0, (globe_diam/2) - 1])
						cylinder(h=cyl_h+1, d1=axle_diam, d2=axle_diam/1.5);
					translate([0, 0, (globe_diam/2)+cyl_h-0.02])
						cylinder(h=cyl_h, d1=axle_diam/1.5, d2=0.1);
				}
			}
		}
		// Ring and sockets
		union() {
			ring_h = 7;
			ring_w = 5;
			ring_gap = 1;
			c_diam = 0.5;
			difference() {
				union() {
					rotate([0, 90, 0])
						rotate_extrude()
							translate([(globe_diam/2)+(ring_h/2)+ring_gap, 0, 0])
								minkowski() {
									square([ring_h-c_diam, ring_w-c_diam], center=true);
									circle(d=c_diam);
								}
					// Ribbon Mount
					translate([0, 0, 27])
						rotate([0, 90, 0])
							rotate_extrude()
								translate([4, 0, 0])
									circle(d=2.5);
				}
					for(i = [0:1]) {
						rotate([i*180, 0, 0]) {
							translate([0, 0, (globe_diam/2)])
								cylinder(h = cyl_h, d1 = axle_diam+(tolerance*2), d2=(axle_diam/1.5)+(tolerance*1.5));
							translate([0, 0, (globe_diam/2)+cyl_h-0.02])
								cylinder(h = cyl_h, d1 =(axle_diam/1.5)+(tolerance*1.5) , d2=0.5);
						}
					}
				// Text
				for(i = [0:1]) {
					rotate([0, 0, i*180])
						translate([(ring_w/2)-0.8, -((globe_diam/2)+ring_gap+ring_h), -25.5])
							rotate([90, 0, 90])
								linear_extrude(height=1) {
									if (i==0) {
										import("text_christmas.dxf");
									}
									if (i==1) {
										import("text_solstice.dxf");
									}
								}
				}
			}
		}
	}
}


module bisect() {
	difference() {
		ornament();
		translate([40, 0, 0])
			cube([80, 80, 80], center=true);
	}
}


ornament();
//bisect();

//projector();
//projector_with_mount();
//assembly();
//test();



