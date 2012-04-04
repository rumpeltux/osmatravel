<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
        xmlns:xlink="http://www.w3.org/1999/xlink"
        xmlns:svg="http://www.w3.org/2000/svg" >

    <xsl:include href="vars.xsl"/>

    <xsl:template match="/"> 
    <svg:svg
       xmlns:dc="http://purl.org/dc/elements/1.1/"
       xmlns:cc="http://creativecommons.org/ns#"
       xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
       xmlns:svg="http://www.w3.org/2000/svg"
       xmlns="http://www.w3.org/2000/svg"
       xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
       xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
       id="main"
       version="1.1"
       baseProfile="full"
       width="{$dataWidth}px"
       height="{$dataHeight}px"
       preserveAspectRatio="none"
       viewBox="0 0 {$dataWidth} {$dataHeight}"
       sodipodi:version="0.32"
       inkscape:version="0.46"
       inkscape:output_extension="org.inkscape.output.svg.inkscape"
       sodipodi:docname="overlay.svg">
       <svg:g inkscape:groupmode="layer" inkscape:label="Overlay"
                transform="scale({1 div $scale * $mapScale})">
       </svg:g>
    </svg:svg>
    </xsl:template> 
</xsl:stylesheet>
