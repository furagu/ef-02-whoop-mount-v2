$fn = 100;

main(
    lens_d = 7.8,
    lens_l = 2.8,
    lens_h = 10,

    arm_l = 8,
    arm_h = 4,

    grip_l = 0.75,
    grip_h = 4.9,
    grip_w = 10,

    angle     = 10,
    thickness = 1.2,
    slit      = 3
);

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

            translate([grip_l / 2, 0, 0])
                arm(
                    l      = arm_l,
                    w      = lens_d + thickness * 2,
                    h      = arm_h,
                    slit_w = slit,
                    t      = thickness
                );

            translate([arm_l + grip_l / 2, 0, 0])
            rotate([0, angle, 0])
            translate([-thickness, 0, 0])
                lens_compartment(
                    d = lens_d,
                    l = lens_l,
                    h = lens_h,
                    t = thickness
                );
        }

        translate([-thickness - grip_l, (grip_w - slit) / 2, -1])
            cube(size=[arm_l * 2, slit, grip_h + thickness * 2 + 2]);
    }
}

module lens_compartment() {
    spacer_h = 2;

    full_w = d + t * 2;

    difference() {
        union() {
            cube([l, full_w, h]);

            translate([0, full_w / 2, h])
            rotate([0, 90, 0])
                cylinder(r=full_w / 2, h=l);
        }

        for(pos = [[t, -1, -1], [t, -1, h + spacer_h / 2]]) {
            translate(pos)
                cube(size=[l, full_w + 2, h - spacer_h / 2 + 1]);
        }

        translate([-1, full_w / 2, h])
        rotate([0, 90, 0])
            cylinder(r=d / 2, h=l+2);
    }
}

module arm() {
    reinforsment_w = t * 2 + slit_w;

    cube(size=[l, w, t]);

    translate([0, (w -  reinforsment_w) / 2, 0])
        cube(size=[l, reinforsment_w, h]);
}

module grip() {
    full_l = l + t * 2;
    full_h = h + t * 2;
    slit = 0.4;

    difference() {
        cube(size=[full_l, w, full_h]);

        translate([full_l / 2 + l / 2 - slit, -1 , t])
            cube(size=[slit, w + 2, full_h]);

        translate([(full_l - l) / 2, -1 , t])
            cube(size=[l, w + 2, h]);
    }
}
