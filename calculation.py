import math, sys

size = sys.argv[1]
if '-' in size:
    format, orientation = size.lower().split('-', 1)
    assert format.startswith('a')
    
    a_n = int(format[1:])
    _tmp = [1600, 841, 594, 420, 297, 210, 148, 105, 74, 52]
    dataHeight = _tmp[a_n]
    dataWidth  = _tmp[a_n + 1]
    if orientation == 'landscape':
        dataHeight, dataWidth = dataWidth, dataHeight
        
elif 'x' in size:
    _tmp = size.split('x', 1)
    dataWidth = float(_tmp[0]) # the target image dimensions
    dataHeight = float(_tmp[1])

else:
    raise TypeError("unsupported size specification: %s" % size)

dataurl = sys.argv[2]
placement = sys.argv[3]
numListings = map(int, sys.argv[4:]) # listings count for each category

ratio = dataWidth / dataHeight

class Rect:
    def __init__(self, (x1,y1), (x2,y2)):
        self.x1 = x1
        self.x2 = x2
        self.y1 = y1
        self.y2 = y2
    @property
    def width(self):
        return self.x2-self.x1
    @property
    def height(self):
        return self.y2-self.y1
    def __repr__(self):
        return "(%f,%f)-(%f,%f)[%f,%f]" % (self.x1, self.y1, self.x2, self.y2, self.width, self.height)

bbox = map(float, dataurl.split("bbox=")[1].split(","))
bottomLeftLongitude, bottomLeftLatitude, topRightLongitude, topRightLatitude = bbox
bbox = Rect( (bottomLeftLongitude, bottomLeftLatitude), (topRightLongitude, topRightLatitude) )

middleLatitude = (bbox.y1 + bbox.y2) / 2.0

# convert latitude to radians
latr = middleLatitude * math.pi / 180.0
projection = 1 / math.cos(latr)

bboxWidth = bbox.width * 10000
bboxHeight = bbox.height * 10000 * projection

# now see how we can fix the map
scale = dataHeight / bboxHeight
if dataWidth - bboxWidth * scale < 0:
    # we never want to remove stuff, so make sure we always make it bigger
    scale = dataWidth / bboxWidth

# fitting the bbox of the map into our dimensions will introduce margins
# either on the left or on the bottom
# default is placement on left and bottom, but that can be
# changed using the placement option
leftOffset = dataWidth - bboxWidth * scale
bottomOffset = (dataHeight - bboxHeight * scale) / projection
topOffset = 0
rightOffset = 0
if "top" in placement:
    bottomOffset, topOffset = topOffset, bottomOffset
if "right" in placement:
    leftOffset, rightOffset = rightOffset, leftOffset

# calculate the coordinates for the revised location,
# so that there is all data for the image available
_coords = [bbox.x1 - leftOffset / (10000 * scale),
     bbox.y1 - bottomOffset / (10000 * scale),
     bbox.x2 + rightOffset / (10000 * scale),
     bbox.y2 + topOffset / (10000 * scale)]
dataurl = "http://www.openstreetmap.org/api/0.6/map?bbox=" + ",".join(map(str,_coords))
datafile = "%x.osm" % abs(hash(dataurl))

# just for debugging:
#new_bbox = Rect( (_coords[0], _coords[1]), (_coords[2], _coords[3]))
#new_scale = dataWidth / (bbox.width * 10000)
#new_height = new_bbox.height * 10000 * new_scale * projection
#new_width =  new_bbox.width * 10000 * new_scale

mapScale = 0.8 # scales the map area to a smaller size, but
               # since font-size and stroke-width stay constant,
               # this in-fact increases the font-size slightly
pixelLineHeight = 0.19 # this is fixed and hardcoded in the xsl file

box_border = 10
boxMinWidth = 60 # minimum width for boxes, TODO param?
# calculate how many boxes could possibly fit (at least one)
# and then determine its width
numBoxes = max(1, int((dataWidth - box_border) / boxMinWidth))
boxWidth = (dataWidth - box_border) / numBoxes


lineHeight = 4.25 # 1. / pixelLineHeight
headline = 6.72 / lineHeight # 6.72 is the absolute height
listingLines = sum([i + (headline if i > 0 else 0) for i in numListings])

def _get_box_distribution(nBoxes, height):
    """
    calculates the number of elements that can be fit into each box
    taking the bigger headlines into account
    """
    # TODO this one can also find out the max_height
    cur_height = 0
    cur_elems = 0
    for elems in numListings:
        if elems == 0: continue
        # at least the headline and the first listing have to fit here
        # otherwise, it won't be allowed for this box
        if cur_height + lineHeight * (headline+1) > height:
            # finish the current box and start a new one
            yield cur_elems
            cur_elems = 0
            cur_height = 0
        cur_height += lineHeight * headline
        while elems > 0:
            if cur_height + lineHeight > height: # the next one would not fit
                yield cur_elems
                cur_elems = 0
                cur_height = 0

            cur_elems += 1
            cur_height += lineHeight
            elems -= 1
    # finish the last box
    yield cur_elems

flow_top_margin = 2
flow_bottom_margin = 2
flow_margin = flow_top_margin + flow_bottom_margin

if leftOffset + rightOffset > bottomOffset + topOffset:
    # the map area is extended, such that there is space to the left not covering
    # the main area of interest. Thus we create one box on the left and calculate
    # its attributes:
    boxLocation = "left"
    width = max(leftOffset, rightOffset)
    height = dataHeight - 2*box_border
    numBoxes = 1
    if height < lineHeight * listingLines + flow_margin:
        # this won't fit, the lineHeight is not used anywhere :/
        lineHeight = (height - flow_margin) / listingLines
    else:
        height = lineHeight * listingLines + flow_margin
    boxes = [sum(numListings)] # only one box
else:
    # there is space on the bottom, so we try to fit as many boxes
    # there as possible
    boxLocation = "bottom"
    height = max(bottomOffset, topOffset) * projection
    width  = dataWidth - box_border
    flowHeight = height - flow_margin

    if flowHeight * numBoxes > lineHeight * listingLines:
        height = (lineHeight * listingLines + numBoxes) / numBoxes + flow_margin

    while 1:
        flowHeight = height - flow_margin
        # calculate the number of listings per box
        boxes = list(_get_box_distribution(numBoxes, flowHeight))
        
        if len(boxes) <= numBoxes:
            break
        # we couldn't fit everything. try again with higher boxes
        height += lineHeight

# calculate the first listing-index per box
listing_start = [sum(boxes[0:i])+1 for i in xrange(numBoxes+1)]

# the position of the first box
y = box_border if "top" in placement else dataHeight - box_border - height
x = box_border
nextBox_xoffset = boxWidth
if "right" in placement:
    x = dataWidth - boxWidth * numBoxes
    

# ------- print us a nice xsl file with all the values
keys = locals().keys()
keys.sort()
print """<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
        xmlns:xlink="http://www.w3.org/1999/xlink"
        xmlns:svg="http://www.w3.org/2000/svg"
        xmlns:var="variable">"""

for k in keys:
    v = locals()[k]
    if k.startswith('_') or type(v).__name__ == 'module': continue
    if isinstance(v, list):
        #print '  <xsl:variable name="%s" as="element()*">' % k
        print "  <var:%s>" % k
        for i in v:
            print '    <Item>%s</Item>' % str(i)
        print "  </var:%s>" % k
        print '  <xsl:variable name="%s" select="document(\'\')/*/var:%s/Item" />' % (k, k)
        #print '  </xsl:variable>'
    else:
        print '  <xsl:variable name="%s">%s</xsl:variable>' % (k, str(v))
print "</xsl:stylesheet>"
