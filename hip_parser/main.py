# Christopher Bero

import csv
import random
import math

hip = []
constellations_pruned = []
constellations_line_pairs = []

hp_max = 6.6371
hp_min = -1.0876
hp_offset = 1.0876 + 1.0
hp_div = hp_max + hp_offset + 1.0


def get_random_color():
    letters = '0123456789ABCDEF'
    color = '\"#'
    for i in range(6):
        color += letters[random.randint(0, 15)]
    color += '\"'
    return color


def parse_hip_db():
    with open('hip_main.dat', 'r') as csv_file:
        reader = csv.reader(csv_file, delimiter='|')
        for row in reader:
            hip.append(row)


def parse_constellations():
    with open('constellationship.fab', 'r') as csv_file:
        reader = csv.reader(csv_file, delimiter=' ')
        for row in reader:
            set_row = [i for n, i in enumerate(row) if i not in row[:n]]
            constellations_pruned.append([row[0], set_row[3:]])
            constellations_line_pairs.append([row[0], row[3:]])


def angularSeparation(ra1, dec1, ra2, dec2):
    x = math.cos(dec1) * math.sin(dec2) - math.sin(dec1) * math.cos(dec2) * math.cos(ra2 - ra1)
    y = math.cos(dec2) * math.sin(ra2 - ra1)
    z = math.sin(dec1) * math.sin(dec2) + math.cos(dec1) * math.cos(dec2) * math.cos(ra2 - ra1)
    d = math.atan2(math.sqrt(x*x + y*y), z)
    return d


def get_star_coords(hip_id):
    global hp_max, hp_min
    for row in hip:
        if int(row[1]) == hip_id:
            #print(row[1], row[8], row[9], row[44])
            s_hp = float(row[44])
            # if s_hp > hp_max:
            #     hp_max = s_hp
            # elif s_hp < hp_min:
            #     hp_min = s_hp
            s_hp_mod = 6*(1.0/(s_hp+hp_offset))
            if s_hp_mod > 1.3:
                s_hp_mod = 1.3
            # print(s_hp_mod)
            #return float(row[8]), float(row[9]), s_hp_mod
            return float(row[8]), float(row[9]), 2.0


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    parse_constellations()
    parse_hip_db()
    with open("constellations.scad", 'w') as f:
        f.write('''\nuse </home/berocs/documents/3d-printing/vbas/projector/utils.scad>\n\n''')
        allcon = ""
        for con in constellations_pruned:
            for star in con[1]:
                # print("Star: ", star)
                coords = get_star_coords(int(star))
                # print("coords: ", coords)
                f.write(f's_{star} = [{coords[0]}, {coords[1]}];\n')
                allcon += f'\tstar(s_{star}, ball_d, {coords[2]});\n'
        f.write(f'\n\nmodule all_constellations_points(ball_d, star_d) {{\n{allcon}\n}}\n\n')
        allcon = ""
        for con in constellations_line_pairs:
            allcon += f'\n\t//// {con[0]}\n'
            allcon += f'\tcolor({get_random_color()}) {{\n'
            for s1, s2 in zip(con[1][0::2], con[1][1::2]):
                c1 = get_star_coords(int(s1))
                c2 = get_star_coords(int(s2))
                ang = angularSeparation(c1[1], c1[0], c2[1], c2[0])
                # level = math.log2(ang)
                level = 1
                if ang >= 3:
                    level = 3
                elif ang >= 1.5:
                    level = 2
                allcon += f'\t\tline(s_{s1}, s_{s2}, globe_diam, star_diam, {level}); // s1: [{c1[0]}, {c1[1]}], s2: [{c2[0]}, {c2[1]}]\n'
            allcon += f'\t}}\n'
        f.write(f'\n\nmodule all_constellations_lines(globe_diam, star_diam) {{\n{allcon}\n}}\n\n')
    print(hp_max, hp_min)





# UMa 19  67301 65378 65378 62956 62956 59774 59774 54061 54061 53910 53910 58001 58001 59774 58001 57399 57399 54539 54539 50372 54539 50801 53910 48402 48402 46853 46853 44471 46853 44127 48402 48319 48319 41704 41704 46733 46733 54061

