$fn = 100;

THE_BLESSED_NUMBER = 0.402;

function bless(x) = floor(x / THE_BLESSED_NUMBER) * THE_BLESSED_NUMBER;

slit = 0.4;

// intersection(){
    rotate([0, 90 - 10, 0])
    main(
        lens_d = 8.15,
        lens_l = 1.2,
        lens_h = 11.2,

        arm_l = 8.2,
        arm_h = 3.5,

        grip_l = 0.85,
        grip_h = 4.8,
        grip_w = 10 + slit,

        angle     = 10,
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

            arm_w = slit + thickness * 4;

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
                    arm_w = arm_w
                );
        }

        translate([-thickness - grip_l, (grip_w - slit) / 2, -1])
            cube(size=[arm_l * 2, slit, lens_h]);
    }
}

module grip() {
    full_l = l + t * 2;
    full_h = h + t * 3;
    slit = 0.1;

    difference() {
        cube(size=[full_l, w, full_h]);

        translate([t, -1 , t * 2])
            cube(size=[slit, w + 2, full_h]);

        translate([(full_l - l) / 2, -1 , t * 2])
            cube(size=[l, w + 2, h]);
    }
}

module arm() {
    reinforsment_w = t * 2 + slit_w;

    cube(size=[l, w, t]);

    translate([0, (w -  reinforsment_w) / 2, 0])
        cube(size=[l, reinforsment_w, h]);
}

module lens_compartment() {
    spacer_h = 2;

    full_w = d + t * 2;

    difference() {
        union() {
            translate([0, (full_w - arm_w) / 2, 0])
                cube([l, arm_w, h]);

            translate([0, full_w / 2, h])
            rotate([0, 90, 0])
                cylinder(r=full_w / 2, h=l);
        }

        translate([-1, full_w / 2, h])
        rotate([0, 90, 0])
            cylinder(r=d / 2, h=l+2);
    }
}
