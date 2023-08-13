class_name BlobTiling

"""
Returns the blob tiling for a set of grid coordinates

See http://www.cr31.co.uk/stagecast/wang/blob.html

:params coords: Array of Vector2i coordinates
:return: Dictionary from input coordinates to 12x4 blob tile atlas coordinates
"""
static func blob_tile(coords : Array) -> Dictionary:
    var nb_bits = {} # Vector2i -> neighbour bits

    var pos_nb: Vector2i # neighbouring position
    for pos in coords:
        # north edge
        pos_nb = pos + Vector2i.UP
        bitwise_or_at_key(nb_bits, pos_nb, SOUTH_EDGE)
        # east edge
        pos_nb = pos + Vector2i.RIGHT
        bitwise_or_at_key(nb_bits, pos_nb, WEST_EDGE)
        # south edge
        pos_nb = pos + Vector2i.DOWN
        bitwise_or_at_key(nb_bits, pos_nb, NORTH_EDGE)
        # west edge
        pos_nb = pos + Vector2i.LEFT
        bitwise_or_at_key(nb_bits, pos_nb, EAST_EDGE)

        # north-east corner
        pos_nb = pos + Vector2i.UP + Vector2i.RIGHT
        bitwise_or_at_key(nb_bits, pos_nb, SOUTHWEST_CORNER)
        # south-east corner
        pos_nb = pos + Vector2i.DOWN + Vector2i.RIGHT
        bitwise_or_at_key(nb_bits, pos_nb, NORTHWEST_CORNER)
        # south-west corner
        pos_nb = pos + Vector2i.DOWN + Vector2i.LEFT
        bitwise_or_at_key(nb_bits, pos_nb, NORTHEAST_CORNER)
        # north-west corner
        pos_nb = pos + Vector2i.UP + Vector2i.LEFT
        bitwise_or_at_key(nb_bits, pos_nb, SOUTHEAST_CORNER)

    var tilemap_positions = {}
    for pos in coords:
        var raw_nb_bitset = nb_bits.get(pos, EMPTY)
        var nb_bitset = prune_neighbour_bitset(raw_nb_bitset)
        tilemap_positions[pos] = NEIGHBOUR_BITS_TO_TILEMAP_COORDS[nb_bitset]

    return tilemap_positions

# Neighbour bitset
# http://www.cr31.co.uk/stagecast/wang/blob.html
const NORTH_EDGE = 1
const NORTHEAST_CORNER = 2
const EAST_EDGE = 4
const SOUTHEAST_CORNER = 8
const SOUTH_EDGE = 16
const SOUTHWEST_CORNER = 32
const WEST_EDGE = 64
const NORTHWEST_CORNER = 128

const EMPTY = 0
const ALL_CORNERS = NORTHEAST_CORNER | SOUTHEAST_CORNER | SOUTHWEST_CORNER | NORTHWEST_CORNER
const ALL_EDGES = NORTH_EDGE | EAST_EDGE | SOUTH_EDGE | WEST_EDGE

static func bitwise_or_at_key(dict : Dictionary, key, value):
    if dict.has(key):
        dict[key] |= value
    else:
        dict[key] = value

"""
Eliminates corners not supported by both neighbouring edges
"""
static func prune_neighbour_bitset(nb_bitset: int):
    var edges = nb_bitset & ALL_EDGES
    var clockwise_corners = edges << 1
    var counterclockwise_corners = (edges >> 1) | ((edges & NORTH_EDGE) << 7) # bring bottom bit back around to the top
    var supported_corners = clockwise_corners & counterclockwise_corners
    var pruned_nb_bitset = nb_bitset & (supported_corners | ALL_EDGES)
    return pruned_nb_bitset

# Manually specified mapping from neighbour bit patterns to tilemap coordinates
# based on the 12x4 tilemap layout we're currently using. Top left corner is
# (0, 0). Invalid blob neighbour bits are sent to (10, 1), the blank cell.
const NEIGHBOUR_BITS_TO_TILEMAP_COORDS = [ \
    Vector2i( 0, 3), # 000
    Vector2i( 0, 2), # 001
    Vector2i(10, 1), # 002
    Vector2i(10, 1), # 003
    Vector2i( 1, 3), # 004
    Vector2i( 1, 2), # 005
    Vector2i(10, 1), # 006
    Vector2i( 8, 3), # 007
    Vector2i(10, 1), # 008
    Vector2i(10, 1), # 009
    Vector2i(10, 1), # 010
    Vector2i(10, 1), # 011
    Vector2i(10, 1), # 012
    Vector2i(10, 1), # 013
    Vector2i(10, 1), # 014
    Vector2i(10, 1), # 015
    Vector2i( 0, 0), # 016
    Vector2i( 0, 1), # 017
    Vector2i(10, 1), # 018
    Vector2i(10, 1), # 019
    Vector2i( 1, 0), # 020
    Vector2i( 1, 1), # 021
    Vector2i(10, 1), # 022
    Vector2i( 4, 2), # 023
    Vector2i(10, 1), # 024
    Vector2i(10, 1), # 025
    Vector2i(10, 1), # 026
    Vector2i(10, 1), # 027
    Vector2i( 8, 0), # 028
    Vector2i( 4, 1), # 029
    Vector2i(10, 1), # 030
    Vector2i( 8, 1), # 031
    Vector2i(10, 1), # 032
    Vector2i(10, 1), # 033
    Vector2i(10, 1), # 034
    Vector2i(10, 1), # 035
    Vector2i(10, 1), # 036
    Vector2i(10, 1), # 037
    Vector2i(10, 1), # 038
    Vector2i(10, 1), # 039
    Vector2i(10, 1), # 040
    Vector2i(10, 1), # 041
    Vector2i(10, 1), # 042
    Vector2i(10, 1), # 043
    Vector2i(10, 1), # 044
    Vector2i(10, 1), # 045
    Vector2i(10, 1), # 046
    Vector2i(10, 1), # 047
    Vector2i(10, 1), # 048
    Vector2i(10, 1), # 049
    Vector2i(10, 1), # 050
    Vector2i(10, 1), # 051
    Vector2i(10, 1), # 052
    Vector2i(10, 1), # 053
    Vector2i(10, 1), # 054
    Vector2i(10, 1), # 055
    Vector2i(10, 1), # 056
    Vector2i(10, 1), # 057
    Vector2i(10, 1), # 058
    Vector2i(10, 1), # 059
    Vector2i(10, 1), # 060
    Vector2i(10, 1), # 061
    Vector2i(10, 1), # 062
    Vector2i(10, 1), # 063
    Vector2i( 3, 3), # 064
    Vector2i( 3, 2), # 065
    Vector2i(10, 1), # 066
    Vector2i(10, 1), # 067
    Vector2i( 2, 3), # 068
    Vector2i( 2, 2), # 069
    Vector2i(10, 1), # 070
    Vector2i( 5, 3), # 071
    Vector2i(10, 1), # 072
    Vector2i(10, 1), # 073
    Vector2i(10, 1), # 074
    Vector2i(10, 1), # 075
    Vector2i(10, 1), # 076
    Vector2i(10, 1), # 077
    Vector2i(10, 1), # 078
    Vector2i(10, 1), # 079
    Vector2i( 3, 0), # 080
    Vector2i( 3, 1), # 081
    Vector2i(10, 1), # 082
    Vector2i(10, 1), # 083
    Vector2i( 2, 0), # 084
    Vector2i( 2, 1), # 085
    Vector2i(10, 1), # 086
    Vector2i( 7, 0), # 087
    Vector2i(10, 1), # 088
    Vector2i(10, 1), # 089
    Vector2i(10, 1), # 090
    Vector2i(10, 1), # 091
    Vector2i( 5, 0), # 092
    Vector2i( 7, 3), # 093
    Vector2i(10, 1), # 094
    Vector2i( 8, 2), # 095
    Vector2i(10, 1), # 096
    Vector2i(10, 1), # 097
    Vector2i(10, 1), # 098
    Vector2i(10, 1), # 099
    Vector2i(10, 1), # 100
    Vector2i(10, 1), # 101
    Vector2i(10, 1), # 102
    Vector2i(10, 1), # 103
    Vector2i(10, 1), # 104
    Vector2i(10, 1), # 105
    Vector2i(10, 1), # 106
    Vector2i(10, 1), # 107
    Vector2i(10, 1), # 108
    Vector2i(10, 1), # 109
    Vector2i(10, 1), # 110
    Vector2i(10, 1), # 111
    Vector2i(11, 0), # 112
    Vector2i( 7, 1), # 113
    Vector2i(10, 1), # 114
    Vector2i(10, 1), # 115
    Vector2i( 6, 0), # 116
    Vector2i( 4, 3), # 117
    Vector2i(10, 1), # 118
    Vector2i( 9, 1), # 119
    Vector2i(10, 1), # 120
    Vector2i(10, 1), # 121
    Vector2i(10, 1), # 122
    Vector2i(10, 1), # 123
    Vector2i(10, 0), # 124
    Vector2i( 9, 0), # 125
    Vector2i(10, 1), # 126
    Vector2i( 5, 1), # 127
    Vector2i(10, 1), # 128
    Vector2i(10, 1), # 129
    Vector2i(10, 1), # 130
    Vector2i(10, 1), # 131
    Vector2i(10, 1), # 132
    Vector2i(10, 1), # 133
    Vector2i(10, 1), # 134
    Vector2i(10, 1), # 135
    Vector2i(10, 1), # 136
    Vector2i(10, 1), # 137
    Vector2i(10, 1), # 138
    Vector2i(10, 1), # 139
    Vector2i(10, 1), # 140
    Vector2i(10, 1), # 141
    Vector2i(10, 1), # 142
    Vector2i(10, 1), # 143
    Vector2i(10, 1), # 144
    Vector2i(10, 1), # 145
    Vector2i(10, 1), # 146
    Vector2i(10, 1), # 147
    Vector2i(10, 1), # 148
    Vector2i(10, 1), # 149
    Vector2i(10, 1), # 150
    Vector2i(10, 1), # 151
    Vector2i(10, 1), # 152
    Vector2i(10, 1), # 153
    Vector2i(10, 1), # 154
    Vector2i(10, 1), # 155
    Vector2i(10, 1), # 156
    Vector2i(10, 1), # 157
    Vector2i(10, 1), # 158
    Vector2i(10, 1), # 159
    Vector2i(10, 1), # 160
    Vector2i(10, 1), # 161
    Vector2i(10, 1), # 162
    Vector2i(10, 1), # 163
    Vector2i(10, 1), # 164
    Vector2i(10, 1), # 165
    Vector2i(10, 1), # 166
    Vector2i(10, 1), # 167
    Vector2i(10, 1), # 168
    Vector2i(10, 1), # 169
    Vector2i(10, 1), # 170
    Vector2i(10, 1), # 171
    Vector2i(10, 1), # 172
    Vector2i(10, 1), # 173
    Vector2i(10, 1), # 174
    Vector2i(10, 1), # 175
    Vector2i(10, 1), # 176
    Vector2i(10, 1), # 177
    Vector2i(10, 1), # 178
    Vector2i(10, 1), # 179
    Vector2i(10, 1), # 180
    Vector2i(10, 1), # 181
    Vector2i(10, 1), # 182
    Vector2i(10, 1), # 183
    Vector2i(10, 1), # 184
    Vector2i(10, 1), # 185
    Vector2i(10, 1), # 186
    Vector2i(10, 1), # 187
    Vector2i(10, 1), # 188
    Vector2i(10, 1), # 189
    Vector2i(10, 1), # 190
    Vector2i(10, 1), # 191
    Vector2i(10, 1), # 192
    Vector2i(11, 3), # 193
    Vector2i(10, 1), # 194
    Vector2i(10, 1), # 195
    Vector2i(10, 1), # 196
    Vector2i( 6, 3), # 197
    Vector2i(10, 1), # 198
    Vector2i( 9, 3), # 199
    Vector2i(10, 1), # 200
    Vector2i(10, 1), # 201
    Vector2i(10, 1), # 202
    Vector2i(10, 1), # 203
    Vector2i(10, 1), # 204
    Vector2i(10, 1), # 205
    Vector2i(10, 1), # 206
    Vector2i(10, 1), # 207
    Vector2i(10, 1), # 208
    Vector2i( 7, 2), # 209
    Vector2i(10, 1), # 210
    Vector2i(10, 1), # 211
    Vector2i(10, 1), # 212
    Vector2i( 4, 0), # 213
    Vector2i(10, 1), # 214
    Vector2i(10, 3), # 215
    Vector2i(10, 1), # 216
    Vector2i(10, 1), # 217
    Vector2i(10, 1), # 218
    Vector2i(10, 1), # 219
    Vector2i(10, 1), # 220
    Vector2i(10, 2), # 221
    Vector2i(10, 1), # 222
    Vector2i( 5, 2), # 223
    Vector2i(10, 1), # 224
    Vector2i(10, 1), # 225
    Vector2i(10, 1), # 226
    Vector2i(10, 1), # 227
    Vector2i(10, 1), # 228
    Vector2i(10, 1), # 229
    Vector2i(10, 1), # 230
    Vector2i(10, 1), # 231
    Vector2i(10, 1), # 232
    Vector2i(10, 1), # 233
    Vector2i(10, 1), # 234
    Vector2i(10, 1), # 235
    Vector2i(10, 1), # 236
    Vector2i(10, 1), # 237
    Vector2i(10, 1), # 238
    Vector2i(10, 1), # 239
    Vector2i(10, 1), # 240
    Vector2i(11, 2), # 241
    Vector2i(10, 1), # 242
    Vector2i(10, 1), # 243
    Vector2i(10, 1), # 244
    Vector2i(11, 1), # 245
    Vector2i(10, 1), # 246
    Vector2i( 6, 2), # 247
    Vector2i(10, 1), # 248
    Vector2i(10, 1), # 249
    Vector2i(10, 1), # 250
    Vector2i(10, 1), # 251
    Vector2i(10, 1), # 252
    Vector2i( 6, 1), # 253
    Vector2i(10, 1), # 254
    Vector2i( 9, 2), # 255
    ]
