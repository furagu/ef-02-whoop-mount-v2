$fn = 100;

THE_BLESSED_NUMBER = 0.402;

function bless(x) = floor(x / THE_BLESSED_NUMBER) * THE_BLESSED_NUMBER;

slit = 0.2;

angle = 10;

// intersection(){
    rotate([0, 90 - angle, 0])
    main(
        lens_d = 7.7,
        lens_l = 1.2,
        lens_h = 10,

        arm_l = 8.2,
        arm_h = bless(3),

        grip_l = 0.85,
        grip_h = 4.8,
        grip_w = 10 + slit,

        angle     = angle,
        thickness = bless(1.5),
        slit      = slit
    );

    // translate([-20, -20, -10])
    //     cube(size=[100, 100, 2.95], center=false);
// }

module main() {
    difference() {
        union() {
            translate([-grip_l / 2 - thickness, 0, 0])
                grip(
                    l = grip_l,
                    w = grip_w,
                    h = grip_h,
                    t = thickness
                );

            arm_w = bless(thickness * 4 + slit);

            translate([grip_l / 2, (grip_w - arm_w) / 2, 0])
                arm(
                    l      = arm_l,
                    w      = arm_w,
                    h      = arm_h,
                    slit_w = slit,
                    t      = thickness
                );

            translate([arm_l + grip_l / 2, (grip_w - lens_d - thickness * 2) / 2, 0])
            rotate([0, angle, 0])
            translate([-lens_l, 0, 0])
                lens_compartment(
                    d = lens_d,
                    l = lens_l,
                    h = lens_h,
                    t = thickness,
                    arm_w = arm_w,
                    slit_w = slit
                );
        }

        translate([-thickness - grip_l, (grip_w - slit) / 2, -1])
            cube(size=[arm_l * 2, slit, lens_h]);
    }
}

module grip() {
    full_l = l + t * 2;
    full_h = h + t * 2.5;
    slit = 0.1;

    difference() {
        cube(size=[full_l, w, full_h]);

        translate([t, -1 , t * 1.5])
            cube(size=[slit, w + 2, full_h]);

        translate([(full_l - l) / 2, -1 , t * 1.5])
            cube(size=[l, w + 2, h]);

        cut_side = sqrt(2 * t * t);

        translate([slit / 2, -1 , full_h + t / 2])
        rotate([0, 45, 0])
            cube(size=[cut_side, w + 2, cut_side]);

        chamfer = 1.8;
        cut_s = full_h * 2;
        for(ya = [[0, 45], [w, -45]]) {
            translate([0, ya[0], full_h - chamfer])
            rotate([ya[1], 0, 0])
            translate([-cut_s / 2, -cut_s / 2, 0])
                cube(size=[cut_s, cut_s, cut_s]);

        }
    }
}

module arm() {
    reinforsment_w = THE_BLESSED_NUMBER * 4 + slit_w;

    cube(size=[l, w, t]);

    translate([0, (w -  reinforsment_w) / 2, 0])
        cube(size=[l, reinforsment_w, h]);
}

module lens_compartment() {
    spacer_h = 2;

    full_w = d + t * 2;
    reinforsment_w = THE_BLESSED_NUMBER * 4 + slit_w;

    difference() {
        union() {
            translate([0, (full_w - arm_w) / 2, 0])
                cube([l, arm_w, h]);

            horizontal_reinforcement_h = THE_BLESSED_NUMBER * 2;

            reinforcement_tolerance = 0.2;

            translate([-t, (full_w - arm_w) / 2 - t / 2, h - d / 2 - horizontal_reinforcement_h - reinforcement_tolerance])
                cube([l, arm_w + t, horizontal_reinforcement_h]);

            translate([-t, (full_w - reinforsment_w) / 2, 0])
                cube([l, reinforsment_w, h - d / 2 - reinforcement_tolerance]);

            translate([0, full_w / 2, h])
            rotate([0, 90, 0])
            hull() {
                cylinder(r=full_w / 2, h=l);

                translate([t, 0, 0])
                    cylinder(r=full_w / 2, h=l);
            }
        }

        translate([-1, full_w / 2, h])
        rotate([0, 90, 0])
            cylinder(r=d / 2, h=l+2);
    }
}
