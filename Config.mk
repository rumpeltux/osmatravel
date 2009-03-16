################### SETTINGS ######################

# The name of the article in Wikitravel
ARTICLE = Paris/1st_arrondissement

# The name of the border way in OSM
# this is specified in OSM with a name tag
BORDER = 1er Arrondissement

# The parent place in OSM
# this is specifed in OSM with an Is_In tag
IS_IN = Paris

# ORIENTATION can be either "landscape" or "portrait"
ORIENTATION = landscape

# SIZE can be "one-page" or "two-page"
SIZE = two-page

# Do you want a bell to ring when everything is done? (yes or no)
BELL = yes

# How should the listings boxes be placed (manual or auto )
LISTINGS_PLACEMENT = manual

# If using auto listings placement should expand the map to fit them?
# ( yes or no )
EXPAND_FOR_LISTINGS = yes
MIN_LISTINGS_BOX_SIZE=65

# =============== Manual Listings Placement ===============================
#
# If you are using manual placement you will need to configure these values
# The best way to come up with these settings is to draw them in inkscape
# and look at the values this produces.  All values are in pixels.  
#
# Do note that the origin of these maps is in the lower left corner.  Y
# values are lower when the pixels are lower on the screen, and vice-versa,
# just as latitude numbers are lower closer to the equater.  Note that this
# makes it much easier to place boxes along the bottom edge.  Just give
# them a Y value of 4.
#
# The logo will be rendered as centered near the bottom of the 4th box.
#
# If you don't need a particular box just set it's height (BOXn_H) to 0
BOX_WIDTH = 78

BOX1_X = 4
BOX1_Y = 4
BOX1_H = 130

BOX2_X = 84
BOX2_Y = 4
BOX2_H = 92

BOX3_X = 164
BOX3_Y = 4
BOX3_H = 40

BOX4_X = 264
BOX4_Y = 256.8
BOX4_H = 40


