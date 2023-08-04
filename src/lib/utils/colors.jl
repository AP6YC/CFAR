"""
    colors.jl

# Description
Define the color schemes used in the paper results

# Authors
- Sasha Petrenko <petrenkos@mst.edu>
"""

# -----------------------------------------------------------------------------
# CONSTANTS
# -----------------------------------------------------------------------------

"""
Plotting colorscheme.
"""
const COLORSCHEME = :okabe_ito

"""
Plotting fontfamily for all text.
"""
const FONTFAMILY = "Computer Modern"

"""
Yellow-green-9 raw RGB values, range `[0, 1]`.
"""
const YLGN_9_RAW = [
    255	255	229;
    247	252	185;
    217	240	163;
    173	221	142;
    120	198	121;
    65	171	93;
    35	132	67;
    0	104	55;
    0	69	41 ;
]/255.0

"""
Purple-blue-9 raw RGB values, range `[0, 1]`.
"""
const PUBU_9_RAW = [
    255	247	251
    236	231	242
    208	209	230
    166	189	219
    116	169	207
    54	144	192
    5	112	176
    4	90	141
    2	56	88
]/255.0

# -----------------------------------------------------------------------------
# DERIVED CONSTANTS
# -----------------------------------------------------------------------------

# Define the colorschemes from the RGB values

"""
Yellow-green-9 color scheme.
"""
const YLGN_9 = ColorScheme([RGB{Float64}(YLGN_9_RAW[i, :]...) for i = 1:size(YLGN_9_RAW)[1]])

"""
Purple-blue-9 color scheme.
"""
const PUBU_9 = ColorScheme([RGB{Float64}(PUBU_9_RAW[i, :]...) for i = 1:size(PUBU_9_RAW)[1]])

"""
Gradient scheme from a given color scheme
"""
const GRADIENTSCHEME = PUBU_9[5:end]
