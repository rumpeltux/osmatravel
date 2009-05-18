<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
        xmlns:xlink="http://www.w3.org/1999/xlink"
        xmlns:svg="http://www.w3.org/2000/svg" >

    <xsl:template name="defs">
        <!-- SVG Definitions - markers, symbols etc go here -->

            <style id="styles" type="text/css" xmlns="http://www.w3.org/2000/svg">
                /* DO NOT DELETE - Used by osmarender.xsl */
                .untagged-segments {
                    stroke-width: 0.5px;
                    stroke-linejoin: round;
                    stroke-linecap: butt;
                    stroke: #e0e0e0;
                    stroke-dasharray: 0.5,0.5;
                }

                .gate-locked {
                    fill: none;
                    stroke: red;
                    stroke-width: 2px;
                    stroke-opacity: 0;
                    marker-mid: url(#marker-gate-locked);
                }

                .gate-closed {
                    fill: none;
                    stroke: red;
                    stroke-width: 2px;
                    stroke-opacity: 0;
                    marker-mid: url(#marker-gate-closed);
                }

                .gate-open {
                    fill: none;
                    stroke: red;
                    stroke-width: 2px;
                    stroke-opacity: 0;
                    marker-mid: url(#marker-gate-open);
                }
                
                /* Railways - generic styles */
                .railway-casing {
                    stroke-linecap: butt;
                    stroke-linejoin: round;
                    fill: none;
                }

                .railway-core {
                    stroke-linecap: butt;
                    stroke-linejoin: round;
                    fill: none;
                }				


                /* Highways - generic styles */
                .highway-casing {
                    stroke-linecap: square;
                    stroke-linejoin: round;
                    fill: none;
                }

                .highway-core {
                    stroke-linecap: square;
                    stroke-linejoin: round;
                    fill: none;
                }

                .highway-ref {
                    fill: #666666;
                    stroke: white;
                    font-family: "DejaVu Sans";
                    font-weight: normal;
                    text-anchor: middle;
                }

                .highway-name {
                    fill: black;
                    font-family: "DejaVu Sans";
                    font-weight: normal;
                    stroke: white;
                    text-anchor: middle;
                 }

                .bridge-casing {
                    stroke-linecap: butt;
                    stroke-linejoin: round;
                    stroke: #777777;
                    fill: none;
                    marker-start: url(#bridge-casing-start);
                    marker-end: url(#bridge-casing-end);
                }
                
                .bridge-core {
                    stroke-linecap: butt;
                    stroke-linejoin: round;
                    stroke: #f8f8f8;
                    fill: none;
                }

                .tunnel-casing {
                    stroke-linecap: butt;
                    stroke-linejoin: round;
                    fill: none;
                }

                .tunnel-core {
                    stroke-linecap: butt;
                    stroke-linejoin: round;
                    fill: none;
                }

                .tunnel { stroke-dasharray: 0.8, 0.8; }

                .railway-rail-bridge-casing             { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="5.5"/></xsl:call-template>px;; }
                .railway-rail-bridge-core               { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="4.5"/></xsl:call-template>px;; }
                .railway-rail-casing                    { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="1.0"/></xsl:call-template>px;; stroke: #aaaaaa; }
                .railway-rail-1-core                    { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="1.9"/></xsl:call-template>px;; stroke: #ffffff; }
                .railway-rail-2-core                    { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="0.7"/></xsl:call-template>px;; stroke: #000000; }

                .railway-light-rail-bridge-casing       { stroke-width: 4.1px; }
                .railway-light-rail-bridge-core         { stroke-width: 3.1px; }
                .railway-light-rail-casing              { stroke-width: 1.0px; stroke: #aaaaaa; }
                .railway-light-rail-core                { stroke-width: 0.7px; stroke: #ec2d2d; }

                .railway-subway-bridge-casing           { stroke-width: 4.1px; }
                .railway-subway-bridge-core             { stroke-width: 3.1px; }
                .railway-subway-casing                  { stroke-width: 1.0px; stroke: #aaaaaa; }
                .railway-subway-core                    { stroke-width: 0.7px; stroke: #ec2d2d; }

                .railway-tram-bridge-casing             { stroke-width: 4.1px; }
                .railway-tram-bridge-core               { stroke-width: 3.1px; }
                .railway-tram-casing                    { stroke-width: 1.0px; stroke: #aaaaaa; }
                .railway-tram-core                      { stroke-width: 0.7px; stroke: #ec2d2d; }

                .railway-narrow-gauge-bridge-casing     { stroke-width: 4.1px; }
                .railway-narrow-gauge-bridge-core       { stroke-width: 3.1px; }
                .railway-narrow-gauge-casing            { stroke-width: 1.0px; stroke: #aaaaaa; }
                .railway-narrow-gauge-core              { stroke-width: 0.7px; stroke: #ec2d2d; }

                .railway-preserved-bridge-casing        { stroke-width: 4.7px; }
                .railway-preserved-bridge-core          { stroke-width: 3.7px; }
                .railway-preserved-casing               { stroke-width: 2.2px; stroke: #666666; }
                .railway-preserved-core                 { stroke-width: 0.6px; stroke: #666666; }
          
                .railway-monorail-bridge-casing         { stroke-width: 4.5px; }
                .railway-monorail-bridge-core           { stroke-width: 3.5px; }
                .railway-monorail-casing                { stroke-width: 2.0px; stroke: #666666; }
                .railway-monorail-core                  { stroke-width: 0.8px; stroke: #a65ca3; }

                .highway-motorway-bridge-casing         { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="4.6"/></xsl:call-template>px; }
                .highway-motorway-bridge-core           { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="4.2"/></xsl:call-template>px; }
                .highway-motorway-casing				{ stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="3.8"/></xsl:call-template>px;  stroke: #777777; }
                .highway-motorway-core					{ stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="3.4"/></xsl:call-template>px;  stroke: #809BC0; }
                .highway-motorway-name                  { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px; }
                .highway-motorway-ref                   { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="4"/></xsl:call-template>px; }

                .highway-trunk-bridge-casing            { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="4.6"/></xsl:call-template>px; }
                .highway-trunk-bridge-core              { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="4.2"/></xsl:call-template>px; }
                .highway-trunk-casing                   { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="3.4"/></xsl:call-template>px;     stroke: #777777; }
                .highway-trunk-core                     { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="3"/></xsl:call-template>px;  stroke: #ffffff; }
                .highway-trunk-name                     { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px; }
                .highway-trunk-ref                      { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="4"/></xsl:call-template>px; }

                .highway-primary-bridge-casing          { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="4.6"/></xsl:call-template>px; }
                .highway-primary-bridge-core            { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="4.2"/></xsl:call-template>px; }
                .highway-primary-casing                 { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="3.4"/></xsl:call-template>px;     stroke: #777777; }
                .highway-primary-core                   { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="3"/></xsl:call-template>px;  stroke: #ffffff; }
                .highway-primary-name                   { stroke-width: 0px;  font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px; }
                .highway-primary-ref					{ stroke-width: 0px;  font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="4"/></xsl:call-template>px; }

                .highway-motorway-link-bridge-casing    { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="4.6"/></xsl:call-template>px; }
                .highway-motorway-link-bridge-core      { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="4.2"/></xsl:call-template>px; }
                .highway-motorway-link-casing           { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="3.4"/></xsl:call-template>px;     stroke: #777777; }
                .highway-motorway-link-core             { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="3"/></xsl:call-template>px;  stroke: #ffffff; }
                .highway-motorway-link-name             { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px; }
                .highway-motorway-link-ref              { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="4"/></xsl:call-template>px; }

                .highway-trunk-link-bridge-casing       { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="4.6"/></xsl:call-template>px; }
                .highway-trunk-link-bridge-core         { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="4.2"/></xsl:call-template>px; }
                .highway-trunk-link-casing              { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="3.4"/></xsl:call-template>px;     stroke: #777777; }
                .highway-trunk-link-core                { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="3"/></xsl:call-template>px;  stroke: #ffffff; }
                .highway-trunk-link-name                { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px; }
                .highway-trunk-link-ref                 { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="4"/></xsl:call-template>px; }

                .highway-primary-link-bridge-casing     { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="4.6"/></xsl:call-template>px; }
                .highway-primary-link-bridge-core       { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="4.2"/></xsl:call-template>px; }
                .highway-primary-link-casing            { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="3.4"/></xsl:call-template>px;  stroke: #777777; }
                .highway-primary-link-core              { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="3"/></xsl:call-template>px;   stroke: #ffffff; }
                .highway-primary-link-name              { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px; }
                .highway-primary-link-ref               { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="4"/></xsl:call-template>px; }

                .highway-secondary-bridge-casing        { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="4.6"/></xsl:call-template>px; }
                .highway-secondary-bridge-core          { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="4.2"/></xsl:call-template>px; }
                .highway-secondary-casing				{ stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="3.4"/></xsl:call-template>px;	 stroke: #777777; }
                .highway-secondary-core                 { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="3"/></xsl:call-template>px;  stroke: #ffffff; }
                .highway-secondary-name                 { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px;}
                .highway-secondary-ref                  { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="4"/></xsl:call-template>px; }

                .highway-tertiary-bridge-casing         { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="4.6"/></xsl:call-template>px; }
                .highway-tertiary-bridge-core           { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="4.2"/></xsl:call-template>px; }
                .highway-tertiary-casing                { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="3.4"/></xsl:call-template>px;  stroke: #777777; }
                .highway-tertiary-core                  { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="3"/></xsl:call-template>px;   stroke: #ffffff; }
                .highway-tertiary-name                  { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px; }
                .highway-tertiary-ref					{ stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="3"/></xsl:call-template>px; }

                .highway-unclassified-bridge-casing     { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="3.1"/></xsl:call-template>px; }
                .highway-unclassified-bridge-core       { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2.9"/></xsl:call-template>px; }
                .highway-unclassified-casing            { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2.5"/></xsl:call-template>px;  stroke: #777777; }
                .highway-unclassified-core              { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2.25"/></xsl:call-template>px;   stroke: #ffffff; }
                .highway-unclassified-name              { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px; }
                .highway-unclassified-ref               { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px; }

                .highway-service-bridge-casing          { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2.8"/></xsl:call-template>px; }
                .highway-service-bridge-core            { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2.6"/></xsl:call-template>px; }
                .highway-service-casing                 { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px;   stroke: #777777; }
                .highway-service-core                   { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2"/></xsl:call-template>px;   stroke: #ffffff; }
                .highway-service-name                   { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px; }
                .highway-service-ref                    { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px; }

                .highway-unsurfaced-bridge-casing       { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2.8"/></xsl:call-template>px; }
                .highway-unsurfaced-bridge-core         { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2.6"/></xsl:call-template>px; }
                .highway-unsurfaced-casing              { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px;   stroke: #777777; stroke-dasharray: 2, 1; stroke-linecap: butt; }
                .highway-unsurfaced-core                { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2"/></xsl:call-template>px;   stroke: #ffffff; }
                .highway-unsurfaced-name                { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px; }
                .highway-unsurfaced-ref                 { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px; }

                .highway-track-bridge-casing            { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2.8"/></xsl:call-template>px; }
                .highway-track-bridge-core              { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2.6"/></xsl:call-template>px; }
                .highway-track-casing                   { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px;   stroke: #d79331; }
                .highway-track-core                     { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2"/></xsl:call-template>px;   stroke: #ffffff; }
                .highway-track-name                     { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px; }
                .highway-track-ref                      { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px; }

                .highway-byway-bridge-casing            { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2.8"/></xsl:call-template>px; }
                .highway-byway-bridge-core              { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2.6"/></xsl:call-template>px; }
                .highway-byway-1-casing                 { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2"/></xsl:call-template>px;     stroke: #555555;  stroke-dasharray: 1.4, 0.4; stroke-linecap: butt;}
                .highway-byway-2-casing                 { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="1.6"/></xsl:call-template>px;   stroke: #efadaa; }
                .highway-byway-3-casing                 { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2.8"/></xsl:call-template>px;   stroke: #555555;  stroke-dasharray: 0.2, 1.6; stroke-dashoffset: 1.2; stroke-linecap: butt; }
                .highway-byway-1-core                   { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="0.8"/></xsl:call-template>px;   stroke: #efadaa; }
                .highway-byway-name                     { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.5"/></xsl:call-template>px; }
                .highway-byway-ref                      { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.5"/></xsl:call-template>px; }

                .highway-bridleway-bridge-casing        { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="3.0"/></xsl:call-template>px; }
                .highway-bridleway-bridge-core          { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2.8"/></xsl:call-template>px; }
                .highway-bridleway-casing               { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2"/></xsl:call-template>px;     stroke: #777777;  stroke-dasharray: 1.4, 0.4; stroke-linecap: butt; }
                .highway-bridleway-core                 { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="1.6"/></xsl:call-template>px;   stroke: #e3e9f1; }
                .highway-bridleway-name                 { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px; }
                .highway-bridleway-ref                  { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px; }

                .highway-cycleway-bridge-casing         { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2.8"/></xsl:call-template>px; }
                .highway-cycleway-bridge-core           { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2.6"/></xsl:call-template>px; }
                .highway-cycleway-casing                { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="1.8"/></xsl:call-template>px;     stroke: #777777; stroke-dasharray: 0.4, 0.4; stroke-linecap: butt;}
                .highway-cycleway-core                  { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="1.6"/></xsl:call-template>px;   stroke: #d1ead1; }
                .highway-cycleway-name                  { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px; }
                .highway-cycleway-ref                   { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px; }

                .highway-pedestrian-bridge-casing       { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="3.4"/></xsl:call-template>px; }
                .highway-pedestrian-bridge-core         { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="3.2"/></xsl:call-template>px; }
                .highway-pedestrian-casing              { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px;   stroke: #aaaaaa; }
                .highway-pedestrian-core                { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2"/></xsl:call-template>px;     stroke: #eeeeee; }
                .highway-pedestrian-name                { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px; }
                .highway-pedestrian-ref                 { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="3"/></xsl:call-template>px; }

                .highway-footway-bridge-casing          { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px; }
                .highway-footway-bridge-core            { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2"/></xsl:call-template>px; }
                .highway-footway-casing                 { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="1.2"/></xsl:call-template>px;   stroke: #777777; stroke-dasharray: 0.4, 0.4; stroke-linecap: butt;}
                .highway-footway-core                   { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="1"/></xsl:call-template>px;     stroke: #efeaa0; }
                .highway-footway-name                   { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px; }
                .highway-footway-ref                    { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px; }

                .highway-steps-bridge-casing            { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px; }
                .highway-steps-bridge-core              { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="2"/></xsl:call-template>px; }
                .highway-steps-casing                   { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="1.2"/></xsl:call-template>px;   stroke: #777777; }
                .highway-steps-core                     { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="1"/></xsl:call-template>px;     stroke: #e5e0c2; stroke-dasharray: 0.6, 0.2; stroke-linecap: butt;}
                .highway-steps-name                     { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px; }
                .highway-steps-ref                      { stroke-width: 0px;     font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="3"/></xsl:call-template>px; }

                .highway-scramble-core                  { stroke-width: <xsl:call-template name="adjustZoom"><xsl:with-param name="value" select="0.3"/></xsl:call-template>px;   stroke: #777777; stroke-dasharray: 1.6, 0.4; stroke-linecap: butt;}
                .highway-scramble-name                  { stroke-width: 1.0px;   fill: black;  font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.2"/></xsl:call-template>px; }
                
                /* Aeroways */
                .aeroway-apron {
                    stroke-width: 0.6px;
                    stroke: none;
                    fill: #f0f0f0;
                }

                .aeroway-taxiway-casing {
                    stroke-width: 6px;
                    stroke-linecap: butt;
                    stroke-linejoin: round;
                    stroke: #000000;
                    fill: none;
                }

                .aeroway-taxiway-core {
                    stroke-width: 4px;
                    stroke-linecap: butt;
                    stroke-linejoin: round;
                    stroke: #d4dcbd;
                    fill: none;
                }

                .aeroway-runway-core {
                    stroke-width: 10px;
                    stroke-linecap: square;
                    stroke-linejoin: round;
                    stroke: #d4dcbd;
                    fill: none;
                }

                .aeroway-runway-casing {
                    stroke-width: 14px;
                    stroke-linecap: square;
                    stroke-linejoin: round;
                    stroke: #000000;
                    fill: none;
                }

                .aeroway-aerodrome-caption {
                    fill: black;
                    stroke: white;
                    stroke-width: 0.6px;
                    font-family: "DejaVu Sans";
                    font-size: 12px;
                    font-weight: bold;
                }

                .aeroway-airport-caption {
                    fill: black;
                    stroke: white;
                    stroke-width: 0.6px;
                    font-family: "DejaVu Sans";
                    font-size: 20px;
                    font-weight: bold;
                }


                /* Waterways */
                .waterway-name-casing { 
                    stroke: #333333; 
                    fill: white; 
                    font-family: "DejaVu Sans"; 
                    font-weight: bold; 
                    text-anchor: middle; 
                    stroke-miterlimit: 1.5;
                }

                .waterway-name-core {
                    stroke: green;
                    fill: white;
                    stroke-width: 0px;
                    font-family: "DejaVu Sans";
                    font-weight: bold;
                    text-anchor: middle;
                    stroke-miterlimit: 1.5;
                }

                .waterway-casing {
                    stroke-linecap: round;
                    stroke-linejoin: round;
                    stroke: #424de8;
                    fill: none;
                }

                .waterway-core {
                    stroke-linecap: round;
                    stroke-linejoin: round;
                    stroke: #424de8;
                    fill: none;
                }

                .waterway-riverbank {
                    fill: #424de8;
                    stroke: #aaaaaa;
                    stroke-width: 0px;
                }

                .waterway-river-casing                  { stroke-width: 6px; }
                .waterway-river-core                    { stroke-width: 4px; }
                .waterway-river-name-casing             { font-size: 3px; stroke-width: 0.2px;}
                .waterway-river-name-core               { font-size: 3px; }

                .waterway-stream-casing                 { stroke-width: 1px; }
                .waterway-stream-core                   { stroke-width: 0.8px; }
                .waterway-stream-name-casing            { font-size: 3px; stroke-width: 0.2px;}
                .waterway-stream-name-core              { font-size: 3px; }

                .waterway-canal-casing                  { stroke-width: 4px; }
                .waterway-canal-core                    { stroke-width: 2px; }
                .waterway-canal-name-casing             { font-size: 3px; stroke-width: 0.2px;}
                .waterway-canal-name-core               { font-size: 3px; }

                .waterway-drain-casing                  { stroke-width: 2px; }
                .waterway-drain-core                    { stroke-width: 1px; }
                .waterway-drain-name-casing             { font-size: 3px; stroke-width: 0.2px;}
                .waterway-drain-name-core               { font-size: 3px; }


                /* Generic under-construction style - makes any way dashed */
                .under-construction { stroke: #f8f8f8; stroke-dasharray: 8, 10; }


                /* Ferry */
                .route-ferry {
                    stroke-width: 1px;
                    stroke-dasharray: 6,4;
                    stroke-linecap: butt;
                    stroke-linejoin: round;
                    stroke: #777777;
                    fill: none;
                }


                /* Place names */
                /* General style for captions */
                .place-caption {
                    fill: black;
                    stroke: none;
                    font-family: "DejaVu Sans";
                    font-weight: bold;
                    text-anchor: middle;
                }

                .caption-casing {
                    fill: white;
                    stroke: white;
                    font-family: "DejaVu Sans";
                    font-weight: bold;
                    text-anchor: middle;
                    stroke-miterlimit: 1.5;
                }

                .caption-core {
                    stroke: white;
                    stroke-width: 0px;
                    font-family: "DejaVu Sans";
                    font-weight: bold;
                    text-anchor: middle;
                    stroke-miterlimit: 1.5;
                }

                .peak-caption           { font-size: 4px; }
                .village-caption        { font-size: 6px; }
                .suburb-caption         { font-size: 6px; }
                .hamlet-caption         { font-size: 4px; }
                .farm-caption           { font-size: 3px; }


                /* Natural */
                .natural-water {
                    fill: url(#water-pattern);
                    stroke: #3333aa;
                    stroke-width: 0.2px;
                }

                .natural-coastline {
                    fill: #424de8;
                    stroke: #424de8;
                    stroke-width: 0.8px;
                }

                .natural-land {
                    fill: #ffffff;
                    stroke: #e0e0e0;
                    stroke-width: 0.2px;
                }

                .natural-beach {
                    fill: #eecc55;
                    stroke: none;
                }

                /* Landuse */
                .landuse-wood {
                    fill: #72bf81;
                    stroke: #6fc18e;
                    stroke-width: 0.2px;
                }

                .landuse-cemetery {
                    fill: url(#cemetery-pattern);
                    stroke: #eeeeee;
                    stroke-width: 0.2px;
                }

                .landuse-cemetery-christian {
                    fill: url(#cemetery-christian-pattern);
                    stroke: #eeeeee;
                    stroke-width: 0.2px;
                }

                .landuse-field {
                    fill: #bde3cb;
                    stroke: #6fc13d;
                    stroke-width: 0.2px;
                }

                .landuse-residential {
                    stroke: none;
                    fill: #f2f2f2;
                }

                .landuse-retail {
                    stroke: none;
                    fill: #ffebeb;
                }

                .landuse-industrial {
                    fill: #f8f8f8;
                    stroke: #eeeeee;
                    stroke-width: 0.2px;
                }

                .landuse-commercial {
                    fill: #fcffc9;
                    stroke: #eeeeee;
                    stroke-width: 0.2px;
                }

                .landuse-retail {
                    fill: #ffebeb;
                    stroke: #eeeeee;
                    stroke-width: 0.2px;
                }

                .landuse-runway {
                  stroke-width: 0.6px;
                  stroke: #808080;
                  fill: #d4dcbd;
                  }

                .landuse-runway-disused {
                  stroke-width: 0.6px;
                  stroke: #808080;
                  fill: #d4dcbd;
                  stroke-dasharray: 2, 2;
                  }

                .landuse-runway-dismantled {
                  stroke-width: 0.6px;
                  stroke: #808080;
                  fill: #fcffef;
                  stroke-dasharray: 0.6, 3.4;
                  opacity: 0.5;
                  }

                .artificial-pier-core {
                  stroke-width: 0.6px;
                  stroke-linecap: butt;
                  stroke-linejoin: round; 
                  stroke: #eeeeee;
                  fill: none;
                  }

                .artificial-pier-casing {
                  stroke-width: 0.8px;
                  stroke-linecap: butt;
                  stroke-linejoin: round; 
                  stroke: #cccccc;
                  fill: none;
                  }

                /* Leisure */
                .leisure-park {
                    fill: #c7f1a3;
                    stroke: #6fc18e;
                    stroke-width: 0.2px;
                }

                .leisure-stadium {
                    fill: #bde3cb;
                    stroke: #6fc18e;
                    stroke-width: 0.2px;
                }

                .leisure-track {
                    fill: #bde3cb;
                    stroke: #6fc18e;
                    stroke-width: 0.2px;
                }

                .sport {
                    fill: #bde3cb;
                    stroke: #6fc18e;
                    stroke-width: 0.2px;
                }

                .amenity-parking {
                    fill: #f7efb7;
                    stroke: #e9dd72;
                    stroke-width: 0.2px;
                }

                .amenity-school {
                    fill: #dfafdd;
                    stroke: #e9dd72;
                    stroke-width: 0.2px;
                }


                /* Non-physical boundaries */
                .boundary {
                    display: none;
                    stroke-linecap: butt;
                    stroke-linejoin: round;
                    fill: none;
                }

                .boundary-administrative-state-casing {
                    display: none;
                    stroke-width: 5px; 
                    stroke: #ffff00;
                    opacity: 0.5;
                }

                .boundary-administrative-state-core {
                    display: none;
                    stroke-width: 0.5px; 
                    stroke: #f9574b;
                    stroke-dasharray: 5, 1, 1, 1;
                }


                .boundary-administrative-parish-core {
                    display: none;
                    stroke-width: 0.5px; 
                    stroke: #f9574b;
                    stroke-dasharray: 5, 1, 1, 1;
                }


                /* Racetracks */
                .highway-raceway-casing {
                  stroke-width: 4px; 
                  stroke-linecap: butt; 
                  stroke-linejoin: round; 
                  fill: none;
                  stroke: #101010;
                  }

                .highway-raceway-casing-disused {
                  stroke-width: 4px; 
                  stroke-linecap: butt; 
                  stroke-linejoin: round; 
                  fill: none;
                  stroke: #808080;
                  stroke-dasharray: 2, 2;
                  }

                .highway-raceway-casing-dismantled {
                  stroke-width: 4px; 
                  stroke-linecap: butt; 
                  stroke-linejoin: round; 
                  fill: none;
                  stroke: #808080;
                  stroke-dasharray: 0.6, 3.4;
                  opacity: 0.5;
                  }

                .highway-raceway-core {
                  stroke-width: 3px; 
                  stroke-linecap: butt; 
                  stroke-linejoin: round; 
                  fill: none;
                  stroke: #f0f0f0;
                  }

                .highway-raceway-core-disused {
                  stroke-width: 3px; 
                  stroke-linecap: butt; 
                  stroke-linejoin: round; 
                  fill: none;
                  stroke-dasharray: 2, 2;
                  stroke: #f7f7f7;
                  }

                .highway-raceway-core-dismantled {
                  stroke-width: 3px; 
                  stroke-linecap: butt; 
                  stroke-linejoin: round; 
                  fill: none;
                  stroke: #fbfbfb;
                  stroke-dasharray: 0.6, 3.4;
                  opacity: 0.5;
                  }
                  
                .landuse-raceway {
                  stroke-width: 0.6px; 
                  stroke-linecap: butt; 
                  stroke-linejoin: round; 
                  fill: #f0f0f0;
                  stroke: #101010;
                  }

                .landuse-raceway-disused {
                  stroke-width: 0.6px; 
                  stroke-linecap: butt; 
                  stroke-linejoin: round; 
                  fill: #f7f7f7;
                  stroke: #808080;
                  stroke-dasharray: 2, 2;
                  }

                .landuse-raceway-dismantled {
                  stroke-width: 0.6px; 
                  stroke-linecap: butt; 
                  stroke-linejoin: round; 
                  fill: #fbfbfb;
                  stroke: #808080;
                  stroke-dasharray: 0.6, 3.4;
                  opacity: 0.5;
                  }


                .railway-station                        { fill: #ec2d2d;        stroke: #666666; stroke-width: 0.5px; }
                .railway-station-caption-casing         { stroke-width: 0.5px;  font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="3"/></xsl:call-template>px;; }
                .railway-station-caption-core           { fill: #ec2d2d;        font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="3"/></xsl:call-template>px;; }

                .railway-halt                           { fill: #ec2d2d;        stroke: #666666; stroke-width: 0.2px; }
                .railway-halt-caption-casing            { stroke-width: 0.4px;  font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.5"/></xsl:call-template>px;; }
                .railway-halt-caption-core              { fill: #ec2d2d;        font-size: <xsl:call-template name="adjustZoomText"><xsl:with-param name="value" select="2.5"/></xsl:call-template>px;; }


                /* Tourism */
                .tourism-attraction {
                    fill: #f2caea;
                    stroke: #f124cb;
                    stroke-width: 0px;
                }

                .tourism-attraction-caption {
                    fill: #f124cb;
                    stroke: white;
                    stroke-width: 0px;
                    font-family: "DejaVu Sans";
                    font-size: 3px;
                    font-weight: bold;
                    text-anchor: middle;
                }


                .generic-caption-casing              { stroke-width: 1px;   font-size: 2px; }
                .generic-caption-core                { fill: #2e3ae6;        font-size: 2px; }

                .generic-poi {
                    fill: #2e3ae6;
                    stroke: #666666;
                    stroke-width: 0.2px;
                }

                /* Building */
                .building {
                    fill: #dddddd;
                    stroke: #cccccc;
                    stroke-width: 0.2px;
                }

                .building-block {
                    fill: #F3D6B6;
                    stroke: #6a5a8e;
                    stroke-width: 0.2px;
                }

                .building-residential {
                    fill: #c95e2a;
                    stroke: #80290a;
                    stroke-width: 0.2px;
                }


                /* Aerialway */
                .aerialway-line {
                    fill: none;
                    stroke: #202020;
                    stroke-width: 0.4px;
                }

                .aerialway-struts {
                    fill: none;
                    stroke: #202020;
                    stroke-width: 4px;
                    stroke-dasharray: 0.4,20;
                }

                /* Power line */
                .power-line {
                    stroke-width: 0.1px;
                    stroke-linecap: butt;
                    stroke-linejoin: round;
                    stroke: #cccccc;
                    stroke-dasharray: 2 ,2;
                    fill: none;
                }


                /* Area captions */
                .park-name {
                    fill: #444444;
                    font-family: "DejaVu Sans";
                    font-weight: normal;
                    stroke: white;
                    font-size: 4.5px;
                    stroke-width: 0.0px;
                 }

                .landuse-reservoir-name {
                    fill: #444444;
                    font-family: "DejaVu Sans";
                    font-weight: normal;
                    stroke: white;
                    font-size: 4.5px;
                    stroke-width: 0.0px;
                 }


                /* Oneway */
                .oneway-casing {
                    fill: none;
                    stroke-linecap: butt;
                    stroke: #777777;
                }

                .oneway-core {
                    fill: none;
                    stroke-linecap: butt;
                    stroke: #ffffff;
                }
                
                .oneway-casing-1 {
                    stroke-width: 0.4px;
                    stroke-dasharray: 4.2,55.8;
                    stroke-dashoffset: 46.2;
                }

                .oneway-casing-2 {
                    stroke-width: 0.95px;
                    stroke-dasharray: 0.6,59.4;
                    stroke-dashoffset: 43.4;
                }

                .oneway-casing-3 {
                    stroke-width: 0.8px;
                    stroke-dasharray: 0.6,59.4;
                    stroke-dashoffset: 43.2;
                }

                .oneway-casing-4 {
                    stroke-width: 0.65px;
                    stroke-dasharray: 0.8,59.2;
                    stroke-dashoffset: 43.2;
                }

                .oneway-casing-5 {
                    stroke-width: 0.5px;
                    stroke-dasharray: 1.0,59;
                    stroke-dashoffset: 43.2;
                }

                .oneway-casing-6 {
                    stroke-width: 0.35px;
                    stroke-dasharray: 1.2,58.8;
                    stroke-dashoffset: 43.2;
                }

                .oneway-casing-7 {
                    stroke-width: 0.2px;
                    stroke-dasharray: 1.4,58.6;
                    stroke-dashoffset: 43.2;
                }

                .oneway-casing-8 {
                    stroke-width: 0.1px;
                    stroke-dasharray: 1.6,58.4;
                    stroke-dashoffset: 43.2;
                }

                .oneway-core-1 {
                    stroke-width: 0.2px;
                    stroke-dasharray: 4,56;
                    stroke-dashoffset: 46;
                }

                .oneway-core-2 {
                    stroke-width: 0.85px;
                    stroke-dasharray: 0.4,59.6;
                    stroke-dashoffset: 43.2;
                }

                .oneway-core-3 {
                    stroke-width: 0.7px;
                    stroke-dasharray: 0.6,59.4;
                    stroke-dashoffset: 43.2;
                }

                .oneway-core-4 {
                    stroke-width: 0.55px;
                    stroke-dasharray: 0.8,59.2;
                    stroke-dashoffset: 43.2;
                }

                .oneway-core-5 {
                    stroke-width: 0.4px;
                    stroke-dasharray: 1.0,59;
                    stroke-dashoffset: 43.2;
                }

                .oneway-core-6 {
                    stroke-width: 0.25px;
                    stroke-dasharray: 1.2,58.8;
                    stroke-dashoffset: 43.2;
                }

                .oneway-core-7 {
                    stroke-width: 0.1px;
                    stroke-dasharray: 1.4,58.6;
                    stroke-dashoffset: 43.2;
                }

                .otherway {
                    fill: none;
                    stroke: red;
                    stroke-width: 2px;
                    stroke-opacity: 0;
                    /* marker-start: url(#marker-otherway-start); */
                    marker-end: url(#marker-otherway-end);
                }


                /* Map decoration */
                .map-grid-line {
                    fill: none;
                    stroke: #8080ff;
                    stroke-width: 0.1px;
                    stroke-opacity: 0.5;
                }

                .map-border-casing {
                    fill: none;
                    stroke: #8080ff;
                    stroke-width: 3px;
                    stroke-miterlimit: 4;
                    stroke-dasharray: none;
                    stroke-opacity: 1;
                    stroke-linecap: round;
                }

                .map-border-core {
                    fill: none;
                    fill-opacity: 1;
                    fill-rule: nonzero;
                    stroke: #ffffff;
                    stroke-width: 2px;
                    stroke-miterlimit: 0;
                    stroke-dashoffset: -0.5px;
                    stroke-opacity: 1;
                }

                .map-scale-casing {
                    fill: none;
                    stroke: #8080ff;
                    stroke-width: 4px;
                    stroke-linecap: butt;
                }

                .map-scale-core {
                    fill: none;
                    stroke: #ffffff;
                    stroke-width: 3px;
                    stroke-linecap: butt;
                }

                .map-scale-bookend {
                    fill: none;
                    stroke: #8080ff;
                    stroke-width: 1px;
                    stroke-linecap: butt;
                }

                .map-scale-caption {
                    font-family: "DejaVu Sans";
                    font-size: 10px;
                    fill: #8080ff;
                }

                <!-- map background must be the same for all zooms or else empty tile detection will fail -->
                .map-background {
                    fill: #d4d4d4;
                    stroke: none;
                }

                .boundary-selected-area {
                    fill: #f8f8f8;
                    stroke: none;
                }

                .map-title {
                    font-family: "DejaVu Sans";
                    font-size: 20px;
                    text-anchor: middle;
                    fill: black;
                }

                .map-title-background {
                    fill: white;
                }

                .map-marginalia-background {
                    fill: white;
                }

                .highway-tunnel-ends {
                    stroke-opacity: 0;
                    fill: none;
                    marker-start: url(#marker-tunnel-start);
                    marker-end: url(#marker-tunnel-end);
                 }

                 .icon-see {
                      fill: #3077bd;
                      fill-opacity: 1;
                      fill-rule: evenodd;
                      font-size: 12;
                      stroke: none;
                 }

                 .icon-sleep {
                      fill: #000088;
                      fill-opacity: 1;
                      fill-rule: evenodd;
                      font-size: 12;
                      stroke: none;
                 }

                 .icon-buy {
                      fill: #00ae98;
                      fill-opacity: 1;
                      fill-rule: evenodd;
                      font-size: 12;
                      stroke: none;
                 }

                 .icon-eat {
                    font-size: 12px;
                    fill: #ac2100;
                    fill-opacity: 1;
                    fill-rule: evenodd;
                 }

                 .icon-drink {
                    font-size: 12px;
                    fill: #810061;
                    fill-opacity: 1;
                    fill-rule: evenodd
                 }

                 .icon-label {
                    font-style: normal;
                    font-variant: normal;
                    font-weight: bold;
                    font-stretch: normal;
                    text-align: center;
                    line-height: 100%;
                    writing-mode: lr-tb;
                    text-anchor: middle;
                    fill: #ffffff;
                    fill-opacity: 1;
                    stroke: none;
                    stroke-width: 1pt;
                    stroke-linecap: butt;
                    stroke-linejoin: miter;
                    stroke-opacity: 1;
                    font-family: Bitstream Vera Sans Mono
                 }

                 .icon-see-label {
                    font-size: 2.8px;
                 }
                 .icon-see-label-big {
                    font-size: 3.2px;
                 }

                 .icon-buy-label {
                    font-size: 2.4px;
                 }
                 .icon-buy-label-big {
                    font-size: 3.0px;
                 }

                 .icon-sleep-label {
                    font-size: 2.6px;
                 }
                 .icon-sleep-label-big {
                    font-size: 3.0px;
                 }

                 .icon-eat-label {
                    font-size: 2.2px;
                 }
                 .icon-eat-label-big {
                    font-size: 2.6px;
                 }

                 .icon-drink-label {
                    font-size: 2.6px;
                 }
                 .icon-drink-label-big {
                    font-size: 3.0px;
                 }

                /* Osmarender built-in styles - do not remove */
                .osmarender-stroke-linecap-round { stroke-linecap: round; }
                .osmarender-stroke-linecap-butt { stroke-linecap: butt; }
                .osmarender-mask-black { stroke: black; }
                .osmarender-mask-white { stroke: white; }
                .osmarender-no-marker-start { marker-start: none; }
                .osmarender-no-marker-end { marker-end: none; }

            </style>

            <svg:pattern id="cemetery-pattern" x="0" y="0" width="10" height="10" patternUnits="userSpaceOnUse" patternTransform="scale(0.25)">
               <svg:rect fill="#bde3cb" width="10" height="10" x="0" y="0" />
               <svg:path fill="#b5b5b5" stroke-width="0.1" d="M 1.48,0.13 C 2.12,0.13 2.63,0.64 2.63,1.28 L 2.63,4.27 L 0.33,4.27 L 0.33,1.28 C 0.33,0.64 0.85,0.13 1.48,0.13 z " />
               <svg:path fill="#b5b5b5" stroke-width="0.1" d="M 6.64,5.78 C 7.27,5.78 7.79,6.29 7.79,6.92 L 7.79,9.91 L 5.49,9.91 L 5.49,6.92 C 5.49,6.29 6.00,5.78 6.64,5.78 z " />
            </svg:pattern>

            <svg:pattern id="cemetery-christian-pattern" x="0" y="0" width="10" height="10" patternUnits="userSpaceOnUse" patternTransform="scale(0.25)">
               <svg:rect fill="#bde3cb" width="11" height="11" x="0" y="0" />
                <svg:path stroke="black" stroke-width="0.2" d="M1,1 L3,1 M2,0 L2,3 M6,6 L8,6 M7,5 L7,8"/>
            </svg:pattern>

            <svg:pattern
               patternUnits="userSpaceOnUse"
               width="5.3520603"
               height="3.2112362"
               patternTransform="translate(268.68454,370.84126)"
               id="water-pattern">
              <svg:g
                 id="g170911"
                 transform="translate(-268.68454,-370.84126)">
                <svg:rect
                   style="fill:#8f96f9;fill-opacity:1;fill-rule:nonzero;stroke:none;stroke-width:0.89999998;stroke-linecap:round;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-dashoffset:0;stroke-opacity:1"
                   width="5.3520603"
                   height="3.2112362"
                   x="268.68454"
                   y="370.84125" />
                <svg:path
                   style="color:#000000;fill:none;fill-opacity:1;fill-rule:evenodd;stroke:#ffffff;stroke-width:0.24698929;stroke-linecap:butt;stroke-linejoin:bevel;marker:none;marker-start:none;marker-mid:none;marker-end:none;stroke-miterlimit:4;stroke-dasharray:none;stroke-dashoffset:0;stroke-opacity:1;visibility:visible;display:inline;overflow:visible"
                   d="M 269.1498,372.00768 C 269.9042,371.97249 269.91405,371.53117 270.46203,371.51559 C 270.96115,371.5014 270.68347,372.01588 271.83989,372.02409"
                   />
                <svg:path
                   style="color:#000000;fill:none;fill-opacity:1;fill-rule:evenodd;stroke:#ffffff;stroke-width:0.24698929;stroke-linecap:butt;stroke-linejoin:bevel;marker:none;marker-start:none;marker-mid:none;marker-end:none;stroke-miterlimit:4;stroke-dasharray:none;stroke-dashoffset:0;stroke-opacity:1;visibility:visible;display:inline;overflow:visible"
                   d="M 270.96408,373.53792 C 271.71848,373.50274 271.72833,373.06142 272.27631,373.04583 C 272.77543,373.03165 272.49775,373.54613 273.65417,373.55434"
                   />
              </svg:g>
            </svg:pattern>


            <svg:marker
                id="bridge-casing-start"
                fill='none'
                stroke-width='0.1px'
                stroke='#777777'
                markerWidth="1px"
                markerHeight="1px"
                orient="auto">
                <svg:path d="M-0.25,0.75 L0.5,0 L-0.25,-0.75" />
            </svg:marker>

            <svg:marker
                id="bridge-casing-end"
                fill='none'
                stroke-width='0.1px'
                stroke='#777777'
                markerWidth="1px"
                markerHeight="1px"
                orient="auto">
                <svg:path d="M0.25,0.75 L-0.5,0 L0.25,-0.75" />
            </svg:marker>

            <svg:marker
                id="marker-tunnel-start"
                viewBox="0 0 10 10"
                refX="5px" refY="5px"
                markerUnits="strokeWidth"
                fill='none'
                stroke-width='0.5px'
                stroke='#777777'
                markerWidth="2px"
                markerHeight="2px"
                orient="auto">
                <svg:path d="M 4,1 A5,4.25 0 0,1 4,9" />
            </svg:marker>

            <svg:marker
                id="marker-tunnel-end"
                viewBox="0 0 10 10"
                refX="5px" refY="5px"
                markerUnits="strokeWidth"
                fill='none'
                stroke-width='0.5px'
                stroke='#777777'
                markerWidth="2px"
                markerHeight="2px"
                orient="auto">
                <svg:path d="M 6,1 A5,4.25 0 0,0 6,9" /> 
            </svg:marker>

            <svg:marker
                id="marker-gate-locked"
                viewBox="0 0 10 10"
                refX="2px" refY="5px"
                markerUnits="userSpaceOnUse"
                fill='none'
                stroke-width='0.4px'
                stroke='#777777'
                markerWidth="3px"
                markerHeight="3px"
                orient="auto">
                <svg:path d="M 1,0 L 1,10 M 3,0 L 3,10" />
            </svg:marker>

            <svg:marker
                id="marker-gate-closed"
                viewBox="0 0 10 10"
                refX="1px" refY="5px"
                markerUnits="userSpaceOnUse"
                fill='none'
                stroke-width='0.4px'
                stroke='#777777'
                markerWidth="3px"
                markerHeight="3px"
                orient="auto">
                <svg:path d="M 1,0 L 1,10" />
            </svg:marker>

            <svg:marker
                id="marker-gate-open"
                viewBox="0 0 11 11"
                refX="1px" refY="5px"
                markerUnits="userSpaceOnUse"
                fill='none'
                stroke-width='0.4px'
                stroke='#777777'
                markerWidth="3px"
                markerHeight="3px"
                orient="auto">
                <svg:path d="M1,0 L1,1 M1,2 L1,3 M1,4 L1,5 M1,6 L1,7 M1,8 L1,9 M1,10 L1,11" />
            </svg:marker>

            <svg:marker
                id="marker-stile"
                viewBox="0 0 10 10"
                refX="5px" refY="5px"
                markerUnits="userSpaceOnUse"
                fill='none'
                stroke-width='0.5px'
                stroke='#777777'
                markerWidth="2px"
                markerHeight="2px"
                orient="auto">
                <svg:path d="M3.5,0 L3.5,10 M6.5,0 L6.5,10 M 10,1 L 1,10" />
            </svg:marker>

            <svg:marker id="marker-otherway-start"   viewBox="0 0 10 10"
                refX="-30px" refY="5px" 
                markerUnits="userSpaceOnUse" 
                fill='#FFFFFF' 
                stroke-width='1px' 
                stroke='#000000' 
                markerWidth="1px" 
                markerHeight="1px" 
                orient="auto">
                <svg:path d="M 10,4 L 4,4 L 4,2 L 0,5 L 4,8 L 4,6 L 10,6 z" />
            </svg:marker>

            <svg:marker id="marker-otherway-end" viewBox="0 0 10 10"
                refX="30px" refY="5px" 
                markerUnits="userSpaceOnUse" 
                fill='#FFFFFF' 
                stroke-width='1px'
                stroke='#000000' 
                markerWidth="1px" 
                markerHeight="1px" 
                orient="auto">
                <svg:path d="M 10,4 L 4,4 L 4,2 L 0,5 L 4,8 L 4,6 L 10,6 z" />
            </svg:marker>

            <svg:symbol
              id="church"
              viewBox="0 0 5 10"
              fill='#000000'>
                <svg:path d="M 0 10 L 0 5 L 5 5 L 5 10 z M 0 2 L 5 2 L 5 3 L 0 3 z M 2 0 L 2 5 L 3 5 L 3 0 z" />
            </svg:symbol>

            <svg:symbol
              id="mosque"
              viewBox="0 0 120 120"
              fill='#00ab00'>
                <svg:path d="M 4,60 C 11,75 60,107 84,73 C 103,40 76,22 50,7 C 76,6 130,35 103,84 C 72,124 8,97 4,60 z M 35,52 C 35,52 20,55 20,55 L 30,43 C 30,43 21,30 21,30 L 35,35 L 45,23 L 45,38 L 60,45 L 45,50 L 45,65 L 35,52 z"/>
            </svg:symbol>

            <svg:symbol
              id="synagogue"
              viewBox="0 0 20 20"
              stroke='#0000d0'
              fill='none'
              stroke-width="1.5px"
              stroke-linecap="butt"
              stroke-linejoin="miter">
                <svg:path d="M 10,0 L 20,15 L 0,15 L 10,0 z M 10,20 L 0,5 L 20,5 L 10,20 z" />
            </svg:symbol>

            <!-- derived from http://www.sodipodi.com/index.php3?section=clipart -->
            <svg:symbol
              id="campSite"
              viewBox="0 0 100 100"
              fill='#0000dc'
              fill-opacity="1">
                <svg:path d="M 35,0 L 50,24 L 65,0 L 80,0 L 60,35 L 100,100 L 0,100 L 40,35 L 20,0 L 35,0 z "/>
            </svg:symbol>

     
            <svg:symbol
              id="airport"
              viewBox="0 0 10 10"
              fill="black"
              fill-opacity="1"
              fill-rule="evenodd"
              stroke="none">
                <svg:path d="M 9.2,5 C 9.2,4.5 9.8,3.2 10,3 L 9,3 L 8,4 L 5.5,4 L 8,0 L 6,0 L 3,4 C 2,4 1,4.2 0.5,4.5 C 0,5 0,5 0.5,5.5 C 1,5.8 2,6 3,6 L 6,10 L 8,10 L 5.5,6 L 7.8,6 L 9,7 L 10,7 C 9.8,6.8 9.2,5.5 9.2,5 z " />
            </svg:symbol>

            <svg:symbol
              id="power-tower"
              viewBox="0 0 10 10"
              stroke-width='1px'
              stroke='#cccccc'>
              <svg:path d="M 0 0 L 10 10 M 0 10 L 10 0" />
            </svg:symbol>

            <!-- derived from http://www.sodipodi.com/index.php3?section=clipart -->
            <svg:symbol
              id="petrolStation"
              viewBox="0 0 115 115"
              fill='#000000'
              fill-rule="evenodd"
              stroke-width="3px">
                <svg:path d="M 22.7283 108.087 C 4.26832 107.546 23.6818 43.3596 32.6686 21.0597 C 33.8491 17.0245 60.28 18.4952 60.0056 19.8857 C 59.0889 25.9148 54.8979 23.2429 52.0142 26.8579 L 51.7464 36.8066 C 48.6085 40.8144 40.2357 34.4677 38.078 42.8773 C 31.3694 92.5727 45.0689 108.819 22.7283 108.087 z M 85.3122 9.52799 L 29.1766 9.52847 C 28.4855 17.5896 -11.559 113.573 22.9292 113.284 C 48.5214 113.073 39.5312 104.08 42.6984 51.03 C 41.8513 49.3228 50.871 48.6585 50.8739 51.4448 L 51.0453 116.604 L 97.6129 116.188 L 97.6129 26.544 C 96.0669 24.2073 93.899 25.2958 90.584 22.394 C 87.7907 19.4131 92.2353 9.52799 85.3122 9.52799 z M 64.0766 35.3236 C 61.5443 36.7258 61.5443 45.2814 64.0766 46.6836 C 68.3819 49.0684 80.2848 49.0684 84.5902 46.6836 C 87.1225 45.2814 87.1225 36.7258 84.5902 35.3236 C 80.2848 32.9393 68.3819 32.9393 64.0766 35.3236 z "/>
            </svg:symbol>

            <!-- derived from http://www.sodipodi.com/index.php3?section=clipart -->
            <svg:symbol
              id="golfCourse"
              viewBox="0 0 100 100"
              fill='#000000'
              fill-rule="evenodd"
              fill-opacity="1"
              stroke="none">
                <svg:path d="M 61.6421 25.2514 C 61.6421 25.2514 48.7712 34.4528 48.1727 38.766 C 47.574 43.0787 56.5537 48.8295 56.8529 52.2802 C 57.1522 55.7303 56.5537 87.3594 56.5537 87.3594 C 56.5537 87.3594 37.3978 104.036 36.7993 105.474 C 36.2006 106.912 41.5878 117.55 43.9826 117.263 C 46.3769 116.975 43.3841 109.787 44.2819 108.349 C 45.1798 106.912 64.0363 92.5353 65.2335 90.5221 C 65.5327 91.0979 65.8321 76.7208 65.5327 76.7208 L 66.7305 76.7208 L 66.1319 91.0979 C 66.1319 91.0979 59.2473 108.349 60.1451 113.237 C 60.1451 115.824 70.6212 122.15 72.1176 121 C 73.6145 119.85 68.5261 115.536 68.8254 112.375 C 67.6283 109.212 73.016 97.4233 73.3153 94.2605 C 73.6145 91.0979 73.9138 56.3053 72.7167 51.9927 C 72.7161 48.542 69.424 42.5037 67.9276 40.2035 C 67.6283 37.9029 65.8326 31.2897 65.8326 31.2897 C 65.8326 31.2897 59.547 39.341 59.5465 39.341 C 58.0501 37.9035 68.2268 28.702 68.2268 25.8268 C 68.2268 22.9513 49.9689 9.72452 49.9689 9.72452 C 49.9689 9.72452 25.126 63.2064 25.4254 65.5065 C 25.7246 67.8065 29.9146 72.9824 32.908 70.6823 C 35.9009 68.3822 27.8197 62.9194 27.8197 62.9194 L 49.3703 14.6122 L 52.6624 18.3506 L 58.3494 18.638 L 58.0501 19.5005 C 58.0501 19.5005 51.7645 18.9255 50.5675 19.788 C 49.3703 20.6506 47.574 22.0887 47.574 25.5388 C 47.574 28.9896 52.0638 30.4271 53.5603 30.7146 L 60.8936 24.6764 L 61.6421 25.2514 z "/>
            </svg:symbol>

            <svg:symbol
              id="slipway"
              viewBox="0 0 50 45"
              fill='#0087ff'
              stroke='none'
              fill-opacity='0.7'>
                <svg:path d="M 45,33 L 45,45 L 2,45 C 2,45 45,33 45,33 z M 0,35 L 43,22 L 43,26 C 43,26 37,32 26,36 C 15,40 0,35 0,35 z M 3,32 C 3,32 13,0 13,0 L 22,26 L 3,32 z M 16,0 L 42,20 L 25,25 L 16,0 z "/>
            </svg:symbol>
            
            <svg:symbol id="cinema" viewBox="150.3 200 320 420">
                <svg:path fill="black" d="M123.7,393.2l-35.9,9L0,50.9l35.9-9L123.7,393.2z"/>
                <svg:path fill="black" d="M291.5,351.2l-35.9,9L167.8,9l35.9-9L291.5,351.2z"/>
                <svg:path fill="black" d="M201.9,27.8l9,35.9L19.8,111.5l-9-35.9L201.9,27.8z"/>
                <svg:path fill="black" d="M234.8,159.2l9,35.9L52.6,242.9l-9-35.9L234.8,159.2z"/>
                <svg:path fill="black" d="M267.7,290.7l9,35.9L85.5,374.4l-9-35.9L267.7,290.7z"/>
                <svg:path fill="#FFFFFF" d="M40.5,97.5l-21.3,5.3l-5.3-21.3l21.3-5.3L40.5,97.5z"/>
                <svg:path fill="#FFFFFF" d="M56.9,163l-21.3,5.3L30.2,147l21.3-5.3L56.9,163z"/>
                <svg:path fill="#FFFFFF" d="M73.3,228.5l-21.3,5.3l-5.3-21.3l21.3-5.3L73.3,228.5z"/>
                <svg:path fill="#FFFFFF" d="M89.6,294l-21.3,5.3L63,278l21.3-5.3L89.6,294z"/>
                <svg:path fill="#FFFFFF" d="M106,359.4l-21.3,5.3l-5.3-21.3l21.3-5.3L106,359.4z"/>
                <svg:path fill="#FFFFFF" d="M209.1,54.3l-21.3,5.3l-5.3-21.3l21.3-5.3L209.1,54.3z"/>
                <svg:path fill="#FFFFFF" d="M225.4,119.8l-21.3,5.3l-5.3-21.3l21.3-5.3L225.4,119.8z"/>
                <svg:path fill="#FFFFFF" d="M241.8,185.3l-21.3,5.3l-5.3-21.3l21.3-5.3L241.8,185.3z"/>
                <svg:path fill="#FFFFFF" d="M258.2,250.8l-21.3,5.3l-5.3-21.3l21.3-5.3L258.2,250.8z"/>
                <svg:path fill="#FFFFFF" d="M274.6,316.3l-21.3,5.3l-5.3-21.3l21.3-5.3L274.6,316.3z"/>
            </svg:symbol>

            <svg:symbol id="theatre" viewBox="220 207 440 550">
                <svg:g stroke="none" fill-opacity="1" fill-rule="nonzero">
                    <svg:path d="M192.4,22c0,0,50,26,112,20s94-39,98-42s17,32,17,32l4,33l-3,29l5,24l7,39l-5,32l-6,32l-19,55l-25,49l-59,21l-30-14l-22-22l-29-47l4-40l-20-28l-18-24l1-34l2-54l-8-35L192.4,22z"/>
                    <svg:path fill="none" stroke="#FFFFFF" stroke-width="10" d="M210.4,44.5c0,0,43.8,22.8,98,17.5s82.3-34.1,85.8-36.8s14.9,28,14.9,28l3.5,28.9l-2.6,25.4l4.4,21l6.1,34.1l-4.4,28l-5.3,28l-16.6,48.1l-21.9,42.9L320.6,328l-26.3-12.3l-19.3-19.3l-25.4-41.1l3.5-35l-17.5-24.5l-15.8-21l0.9-29.8l1.8-47.3l-7-30.6L210.4,44.5z"/>
                    <svg:path fill="#FFFFFF" d="M293.4,152c0,8.3-11.4,15-25.5,15s-25.5-6.7-25.5-15s11.4-15,25.5-15S293.4,143.7,293.4,152z"/>
                    <svg:path fill="#FFFFFF" d="M406.4,140.5c0,8.6-13.2,15.5-29.5,15.5s-29.5-6.9-29.5-15.5s13.2-15.5,29.5-15.5S406.4,131.9,406.4,140.5z"/>
                    <svg:path fill="none" stroke="#FFFFFF" stroke-width="10" d="M248.4,124l14-43l15,27"/>
                    <svg:path fill="none" stroke="#FFFFFF" stroke-width="10" d="M336.4,110l7-32l35,23"/>
                    <svg:path fill="none" stroke="#FFFFFF" stroke-width="10" d="M317.4,146l-7,72l22-1L317.4,146z"/>
                    <path fill="none" stroke="#FFFFFF" stroke-width="10" d="M305.4,297c0,0,2-55,27-57s37,16,41,30"/>
                    <svg:path fill="#FFFFFF" stroke="#000000" stroke-width="10" d="M207.4,90c0,0-19,18-61,17s-42,5-83-33s-31-38-31-38l-9,105l-5,22l-13,15l26,128l37,82c0,0,3,9,38,9s30-10,40-20s15-35,34-49s41-47,41-47l17-21l3-34l-23-29l-12-32L207.4,90z"/>
                    <svg:path fill="none" stroke="#000000" stroke-width="10" d="M51.4,150c0,0-2-15,25-15s31,17,31,17"/>
                    <svg:path fill="none" stroke="#000000" stroke-width="10" d="M153.4,168c0,0,6-11,12-14s22,5,22,5"/>
                    <svg:path d="M51.4,193l23-19c0,0,12-2,25,2s7,14,7,14L51.4,193z"/>
                    <svg:path d="M164.4,199c0,0,14-13,27-10s16,19,16,19s-7,6-26,1S164.4,199,164.4,199z"/>
                    <svg:path d="M125.4,188l-25,83h29L125.4,188z"/>
                    <svg:path d="M61.4,258c0,0,0-4,14,16s10,36,44,34s38-45,55-42s13,8,7,20s-23,23-32,35s5,40-39,38s-43-44-49-48S61.4,258,61.4,258z"/>
                </svg:g>
            </svg:symbol>

            <svg:symbol id="symbol-windmill" viewBox="158 240 315.9 480.2" >
                <svg:path fill="#000000" d="M106.7,148.2l104-1l61,333l-231-1" />
                <svg:path fill="none" stroke="#000000" stroke-width="24" d="M6.7,201 l284-191" />
                <svg:path fill="none" stroke="#000000" stroke-width="24" d="M19.7,17.5 l290,176" />
            </svg:symbol>

            <!-- derived from http://www.sodipodi.com/index.php3?section=clipart -->
            <svg:symbol
              id="hotel"
              viewBox="0 0 90 90"
              fill="black"
              fill-opacity="1"
              stroke="black"
              stroke-width="1px"
              stroke-miterlimit="4">
                <svg:path d="M 0,60 C 0,65 10,65 10,60 L 10,50 L 35,70 L 35,85 C 35,90 45,90 45,85 L 45,70 L 75,70 L 75,85 C 75,90 85,90 85,85 L 85,60 L 40,60 L 5,30 C 9,20 45,20 50,25 L 50,10 C 50,5 40,5 40,10 L 40,15 L 10,15 L 10,10 C 10,5 0,5 0,10 C 0,10 0,60 0,60 z M 10,35 C 15,25 45,25 55,35 L 85,60 C 75,50 40,50 40,60 L 10,35 z "/>
            </svg:symbol>

            <!-- derived from http://www.sodipodi.com/index.php3?section=clipart -->
            <svg:symbol
              id="hostel"
              viewBox="0 0 12.5 8"
              fill="#286a9d"
              fill-opacity="1"
              fill-rule="nonzero"
              stroke="none">
                <svg:path d="M 5.5,4 L 9,0 L 12.5,4 L 11.5,4 L 11.5,8 L 10,8 L 10,5 L 8,5 L 8,8 L 6.5,8 L 6.5,4 L 5.5,4 z M 0.5,3.5 C 2,2.5 2.3,1 2.5,0 C 2.7,1 3,2.5 4.5,3.5 L 3.3,3.5 C 3.3,4 4,5 5,6 L 3,6 L 3,8 L 2,8 L 2,6 L 0,6 C 1,5 1.7,4 1.7,3.5 L 0.5,3.5 z M 0,8 L 0,7.5 L 12.5,7.5 L 12.5,8 L 0,8 z " />
            </svg:symbol>

            <svg:symbol
              id="recycling"
              viewBox="0 0 100 100"
              stroke='none'
              fill='#00ba00'>
                <svg:path d="M 55.0,37.3 L 72.1,27.0 L 79.8,41.9 C 81.6,50.0 71.5,52.9 63.3,52.4 L 55.0,37.3 z" />
                <svg:path d="M 51.1,47.9 L 42.1,63.8 L 51.1,80.0 L 51.3,73.5 L 59.5,73.5 C 62.5,73.8 66.4,71.8 67.9,69.0 L 78.4,49.5 C 75.0,53.0 70.5,53.9 65.3,53.9 L 51.4,53.9 L 51.1,47.9 z " />
                <svg:path d="M 31.0,28.2 L 13.7,18.2 L 22.9,4.2 C 29.0,-1.3 36.6,6.1 40.1,13.5 L 30.9,28.2 z " />
                <svg:path d="M 42.1,26.5 L 60.4,26.6 L 70.1,10.9 L 64.3,13.8 L 60.3,6.6 C 59.1,3.9 55.5,1.4 52.3,1.5 L 30.2,1.7 C 34.9,3.1 37.9,6.6 40.4,11.1 L 47.2,23.3 L 42.1,26.5 z " />
                <svg:path d="M 0.4,27.4 L 5.8,31.5 L 0.8,40.5 C -1.8,45.3 2.6,49.6 5.3,51.0 C 8.0,52.5 12.2,52.7 16.2,52.7 L 23.3,41.3 L 28.6,44.1 L 19.3,27.2 L 0.4,27.4 z " />
                <svg:path d="M 1.2,49.3 L 12.7,70.1 C 15.0,73.0 19.4,73.7 23.9,73.6 L 36.0,73.6 L 36.0,53.9 L 13.0,53.7 C 9.5,53.9 4.8,53.2 1.2,49.3 z " />
            </svg:symbol>

            <svg:symbol
              id="hospital"
              viewBox="0 0 15 15"
              stroke='red'
              stroke-width="2px"
              fill="none">
                <svg:path d="M 12.5,7.5 L 2.5,7.5 L 2.5,7.5 L 12.5,7.5 z M 7.5,2.3 L 7.5,12.5 L 7.5,12.5"/>
                <svg:path stroke-width="1px" d="M 14.5 7.5 A 7 7 0 1 1 0.5,7.5 A 7 7 0 1 1 14.5 7.5 z" />
            </svg:symbol>

            <svg:symbol id="symbol-doctor" viewBox="18 18 36 36">
                <svg:ellipse fill="#00cc00" cx="18" cy="18" rx="18" ry="18"/>
                <svg:path fill="#ffffff" d="M32 21.44 A16 16 -180 1 0 0 21.44 A16 16 -180 1 0 32 21.44 Z M10 6.94 L22 6.94 L22 15.44 L30.5 15.44 L30.5 27.44 L22 27.44 L22 35.94 L10 35.94 L10 27.44 L1.5 27.44 L1.5 15.44 L10 15.44 L 10 6.94 Z" transform="translate(2,-3.44)"/>
            </svg:symbol>

           <svg:symbol id="symbol-pharmacy" viewBox="18 18 36 36">
                <svg:rect style="fill:#00cc00" x="0" y="0" width="36" height="36" rx="2" ry="2"/>
                <svg:path style="fill:#ffffff" d="M20.14 17.3 L20.14 9.44 L11.86 9.44 L11.86 17.3 L4 17.3 
                L4 25.58 L11.86 25.58 L11.86 33.44 L20.14 33.44 L20.14 25.58 L28 25.58 L28 17.3 L20.14 17.3 Z
                M0.5 37.44 L31.5 37.44 a0.5 0.5 -180 0 0 0.5 -0.5 L32 5.94 a0.5 0.5 -180 0 0 -0.5 -0.5 
                L0.5 5.44 a0.5 0.5 -180 0 0 -0.5 0.5 L0 36.94 a0.5 0.5 -180 0 0 0.5 0.5 Z M2 35.44 L2
                7.44 L30 7.44 L30 35.44 L2 35.44 Z"
                transform="translate(2,-3.44)"/>
            </svg:symbol>
            
            <svg:symbol id="postoffice" viewBox="0 0 36 36">
                <svg:ellipse style="fill:#ff0000" cx="18" cy="18" rx="18" ry="18"/>
                <svg:path style="fill:#ffffff" d="M26 25.44 L26 35.44 L2 35.44 L2 25.44 L14 31.44 L26 25.44 Z M2 23.44 L26 23.44 L14 29.44 L2 23.44 Z M0 37.44 L28 37.44 L28 21.44 L0 21.44 L0 37.44 Z" transform="translate(4,-11.44)"/>
            </svg:symbol>
            
            <svg:symbol id="postbox" viewBox="0 0 36 36" xml:space="preserve">
                <svg:ellipse style="fill:#ff0000" cx="18" cy="18" rx="18" ry="18"/>
                <svg:ellipse style="fill:#ffffff" cx="18" cy="18" rx="16" ry="16"/>
                <svg:path style="fill:#ff0000" d="M26 25.44 L26 35.44 L2 35.44 L2 25.44 L14 31.44 L26 25.44 Z M2 23.44 L26 23.44 L14 29.44 L2 23.44 Z M0 37.44 L28 37.44 L28 21.44 L0 21.44 L0 37.44 Z" transform="translate(4,-11.44)"/>
            </svg:symbol>

            <svg:symbol
              id="parking"
              viewBox="0 -10 20 20"
              stroke="none"
              fill-opacity="1"
              fill-rule="nonzero">
                <svg:rect fill="#0087ff" width="20" height="20" x="0" y="-10" rx="4" ry="4" />
                <svg:path fill="white" d="M 5,8 L 5,-7 L 12,-7 C 14,-7 15.5,-5.3 16,-4 C 16.5,-2.77 16.5,-1.23 16,0 C 15.41,1.42 14,3 12,3 L 8,3 L 8,8 L 5,8 z M 8,-4 L 8,0 C 9.3,0 11,0 12.32,-0.31 C 13.6,-0.76 13.5,-2.8 12.5,-3.48 C 11.5,-4.1 8.6,-4 8,-4 z "/>
            </svg:symbol>
            
            <svg:symbol id="symbol-traffic_signal" viewBox="106 278.6 557.3 557.3" >
                <svg:path d="M212.1,105c0,58-47.5,105-106,105c-58.6,0-106-47-106-105 C0,47,47.5,0,106,0C164.6,0,212.1,47,212.1,105z"/>
                <svg:path d="M212.1,452.3c0,58-47.5,105-106,105c-58.6,0-106-47-106-105 c0-58,47.5-105,106-105C164.6,347.3,212.1,394.3,212.1,452.3z"/>
                <svg:path d="M211.3,458.9H0V106.7h211.3V458.9z"/>
                <svg:path fill="#F90000" d="M190,103c0,46.4-37.6,84-84,84 c-46.4,0-84-37.6-84-84s37.6-84,84-84C152.4,19,190,56.6,190,103z"/>
                <svg:path fill="#00D305" d="M190,455c0,46.4-37.6,84-84,84 c-46.4,0-84-37.6-84-84c0-46.4,37.6-84,84-84C152.4,371.1,190,408.7,190,455z"/>
                <svg:path fill="#F9FF00" d="M190,279c0,46.4-37.6,84-84,84 c-46.4,0-84-37.6-84-84c0-46.4,37.6-84,84-84C152.4,195,190,232.6,190,279z"/>
            </svg:symbol>

            <svg:symbol id="symbol-school" viewBox="160 216 320.8 432.5">
                <svg:path fill="#AF7519" d="M93,284.7c0,11-9,20-20,20s-20-9-20-20s9-20,20-20S93,273.7,93,284.7z" />
                <svg:path fill="#AF7519" d="M237,328.7c0,11-9,20-20,20s-20-9-20-20s9-20,20-20S237,317.7,237,328.7z" />
                <svg:path fill="none" stroke="#AF7519" stroke-width="20" d="M163,4.7l-116,361" />
                <svg:path fill="none" stroke="#AF7519" stroke-width="18.9041" d="M163,4.7L232,431" />
                <svg:path fill="none" stroke="#AF7519" stroke-width="20" d="M163,4.7l149,277" />
                <svg:path d="M6,53.7c0,0,283,67,284,70s-3,222-3,222l-287-97L6,53.7z" />
                <svg:path fill="none" stroke="#FFFFFF" stroke-width="20" d="M36,128.7c-1.2-8.1,16.8-17.4,25-17.2 c14.7,0.4,20,10.1,26.8,23.3c7.8,15,10.9,36,12.3,53c0.5,6.2,1.3,40.2,4.9,39.9" />
                <svg:path fill="none" stroke="#FFFFFF" stroke-width="20" d="M94,158.7c-17.5-12.4-58.4,7.4-59,28 c-0.5,17.8,16,23,29.9,26c15.4,3.2,19.2,0.8,29.1-11" />
                <svg:path fill="none" stroke="#FFFFFF" stroke-width="20" d="M136,101.7c-11.6,26.2-2.8,64-5,92.9 c-1.2,16.3,0.7,40.2-2,54.1" />
                <svg:path fill="none" stroke="#FFFFFF" stroke-width="20" d="M131,176.7c10.8-4.2,18.3-17.9,32.8-10 c11.5,6.3,13.7,23.1,14.2,34.9c0.7,15.6-3.3,26.4-18.8,31.8c-7.6,2.7-25.5,5.8-24.2-7.7" />
                <svg:path fill="none" stroke="#FFFFFF" stroke-width="20" d="M261,196.7c-4.1-11.8-20.9-19.9-33.1-16.8 c-16.3,4.2-23.3,25-21.9,40.1c2.3,25.4,29.8,56.5,52,31.7" />
            </svg:symbol>
            
            <svg:symbol id="symbol-university" viewBox="244.5 110 489 219.9">
                <svg:path d="M79,43l57,119c0,0,21-96,104-96s124,106,124,106l43-133l82-17L0,17L79,43z"/>
                <svg:path fill="none" stroke="#000000" stroke-width="20" d="M94,176l-21,39"/>
                <svg:path d="M300,19c0,10.5-22.6,19-50.5,19S199,29.5,199,19s22.6-19,50.5-19S300,8.5,300,19z"/>
                <svg:path fill="none" stroke="#000000" stroke-width="20" d="M112,216l-16-38L64,88c0,0-9-8-4-35s16-24,16-24"/>
            </svg:symbol>
            
            <svg:symbol id="symbol-supermarket" viewBox="14.5 13.5 29 27">
                <svg:path style="fill:black;fill-opacity:1;stroke:none;stroke-width:0.158;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:0.9801324" d="M 13.711,19.263 C 13.711,19.754 13.319,20.153 12.836,20.153 C 12.353,20.153 11.962,19.754 11.962,19.263 C 11.962,18.771793 12.353,18.373 12.836,18.373 C 13.319,18.373 13.711,18.771 13.711,19.263 z" />
                <svg:path style="fill:none;fill-rule:evenodd;stroke:black;stroke-width:1;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1" d="M 1.496,6.889 L 16.443,2.987 L 25.387,6.367 L 7.7960,10.054 L 1.496,6.889 z" />
                <svg:path style="fill:none;fill-rule:evenodd;stroke:black;stroke-width:1;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1" d="M 1.540,16.974 L 7.7331,20.521 L 22.605,17.745 L 14.549,13.961 L 1.540,16.974 z" />
                <svg:path style="fill:none;fill-rule:evenodd;stroke:black;stroke-width:1;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1" d="M 7.812,10.136 L 7.812,20.500" />
                <svg:path style="fill:none;fill-rule:evenodd;stroke:black;stroke-width:1;stroke-linecap:round;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1" d="M 22.841,21.164 L 26.462,6.6923 C 26.610,5.3945 27.232,4.939 28.105,4.932" />
                <svg:path style="fill:none;fill-rule:evenodd;stroke:black;stroke-width:0.90399998;stroke-linecap:round;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1" d="M 14.1281,17.1309 L 16.5851,2.98845 C 16.5652,2.09899 16.8043,1.34902 17.8289,1.02204" />
                <svg:path style="fill:none;fill-rule:evenodd;stroke:black;stroke-width:1;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1" d="M 0.761,16.846 L 0.761,6.781" />
                <svg:path style="fill:none;fill-rule:evenodd;stroke:black;stroke-width:0.160;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1" d="M 17.707,0.991 C 17.727,0.991 17.748,0.991 17.707,0.991 z" />
                <svg:path style="fill:none;fill-rule:evenodd;stroke:black;stroke-width:1.27;stroke-linecap:round;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1" d="M 17.707,1.022 L 28.196,4.902" />
                <svg:path style="fill:none;fill-rule:evenodd;stroke:black;stroke-width:0.732;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1" d="M 14.009,17.240 L 3.853,20.726 C 1.229,21.787 3.228,23.365 4.126,23.909 C 5.447,24.711 6.096,25.159 9.340,24.728 C 13.993,24.109 22.709,21.211 22.709,21.211" />
                <svg:path style="fill:black;fill-opacity:1;stroke:none;stroke-width:0.159;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:0.980" d="M 5.601,21.945 C 5.601,22.437 5.209,22.834 4.727,22.835 C 4.244,22.835 3.853,22.437 3.853,21.945 C 3.853,21.454 4.244,21.056 4.727,21.056 C 5.2095,21.056 5.601,21.454 5.601,21.945 z" />
                <svg:path style="fill:black;fill-opacity:1;stroke:none;stroke-width:0.159;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:0.980" d="M 11.254,25.962 C 11.254,26.453 10.863,26.852 10.380,26.852 C 9.898,26.852 9.506,26.453 9.506,25.962 C 9.506,25.471 9.898,25.072 10.380,25.072 C 10.863,25.072 11.254,25.471 11.254,25.962 z" />
                <svg:path style="fill:black;fill-opacity:1;stroke:none;stroke-width:0.159;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:0.980" d="M 21.926,23.143 C 21.926,23.635 21.535,24.033 21.052,24.033 C 20.569,24.033 20.177,23.632 20.177,23.143 C 20.177,22.652 20.569,22.253 21.052,22.253 C 21.535,22.253 21.926,22.652 21.926,23.143 z" />
            </svg:symbol>

            <svg:symbol id="symbol-library" viewBox="160 310 319.3 621.3">
                <svg:path fill="#FFFFFF" stroke="#000000" stroke-width="32.0585" d="M136,165.5l5.1,414l162.2-163.5V46.6 L136,165.5z"/>
                <svg:path fill="#FFFFFF" stroke="#000000" stroke-width="32.1739" d="M20.2,136.7l-3.9,422.1c0,0-6.4,45,43.8,46.3 c56.6,1.5,68.2-10.3,68.2-10.3l2.6-426c0,0-18,14.2-57.9,12.9C22.8,180.1,20.2,136.7,20.2,136.7z"/>
                <svg:path fill="none" stroke="#000000" stroke-width="26.7171" d="M175.9,229.4l79.8-48.9"/>
                <svg:path fill="none" stroke="#000000" stroke-width="26.7171" d="M182.3,289.9l69.5-42.5"/>
                <svg:path fill="none" stroke="#000000" stroke-width="26.7171" d="M184.9,351.6l75.9-48.9"/>
                <svg:path fill="none" stroke="#000000" stroke-width="26.7171" d="M13.7,147L191.3,10.6 c-18.3,17.1,13.9,32.3,37.3,33.5c51.5,2.6,81.1-7.7,81.1-7.7"/>
                <svg:path fill="#FFFFFF" stroke="#000000" d="M36.7,143.9l144-116c0,0-7,18,26,25s59,1,59,1l-149,107c0,0-27,16-59,1 S36.7,143.9,36.7,143.9z"/>
            </svg:symbol>
            
            <svg:symbol id="speed_trap" viewBox="0 0 72 36">
                <svg:rect style='fill:#ffff00' x="0" y="0" width="36" height="36" rx="2" ry="2" />
                <svg:path style='fill:#000000'
                d="M0.5 37.44 L31.5 37.44 a0.5 0.5 -180 0 0 0.5 -0.5 L32 5.94 a0.5 0.5 -180 0 0 -0.5 -0.5 L0.5 5.44 a0.5 0.5 -180
                0 0 -0.5 0.5 L0 36.94 a0.5 0.5 -180 0 0 0.5 0.5 Z M2 35.44 L2 7.44 L30 7.44 L30 35.44 L2 35.44 Z M8 30.44
                L16 30.44 A3 3 -180 0 0 19 27.44 L19 15.44 A3 3 -180 0 0 16 12.44 L8 12.44 A3 3 -180 0 0 5 15.44 L5 27.44
                A3 3 -180 0 0 8 30.44 Z M14 24.94 A3.5 3.5 0 1 1 7 24.94 A3.5 3.5 0 1 1 14 24.94 Z M13 24.94 A2.5 2.5 -180
                1 0 8 24.94 A2.5 2.5 -180 1 0 13 24.94 Z M17 15.44 A2 2 0 1 1 13 15.44 A2 2 0 1 1 17 15.44 Z M16 15.44 a1
                1 -180 1 0 -2 7.10543E-015 a1 1 -180 1 0 2 -7.10543E-015 Z M20 25.94 L21 25.94 L21 15.44 L20 15.44 L20 25.94
                Z M22 25.94 L23 25.94 L23 16.44 L22 16.44 L22 25.94 Z M20 26.94 L20 27.94 L25 27.94 L25 24.94 L27 24.94
                L27 19.44 L25 19.44 L25 17.44 L24 17.44 L24 26.94 L20 26.94 Z" transform="translate(2,-3.44)"/>
            </svg:symbol>
            
            <svg:symbol id="symbol-railway-crossing" viewBox="-50 -150 600 600" >
                <svg:path fill="#C60936" d="M1.5,4.5l66,1.5l190,91.4L456,0l63,4.5l-15,48
                l-184.5,87l175.5,81l15,51l-58.5,6l-193.5-99c0,0-189,96-193.5,99S0,279,0,279l6-51l172.5-85.5L12,63L1.5,4.5z"/>
                <svg:path fill="#FFFFFF" d="M49.5,21L33,49.5L219,141L36,237l16.5,25.5
                L258,156l196.5,105l21-33l-189-91.5l189-87l-21-30l-196.7,96.7L49.5,21z"/>
            </svg:symbol>
            
            <svg:symbol id="symbol-museum" viewBox="94 140 156 180">
                <svg:g fill="#f2f2f2" stroke-width="3" stroke="#000000">
                    <svg:path d="M 38.2,92.9 L 60.6,92.9 L 60.6,215.6 L 38.2,215.6 L 38.2,92.9 z " />
                    <svg:path d="M 85,92.9 L 107.4,92.8 L 107.4,215.6 L 85,215.6 L 85,92.9 z " />
                    <svg:path d="M 131.8,92.8 L 154.2,92.8 L 154.2,215.6 L 131.8,215.6 L 131.8,92.8 z " />
                    <svg:path d="M 18.0,216.1 L 170.0,216.1 L 170.0,226.6 L 18.0,226.6 L 18.0,216.1 z " />
                    <svg:path d="M 17.9,82.0 L 95.4,53.6 L 169.9,82.0 L 169.9,92.5 L 17.9,92.5 L 17.9,82.0 z " />
                </svg:g>
            </svg:symbol>
            
            <svg:symbol id="symbol-roundabout_right" viewBox="-253.5 253.5 507 507"> 
                <svg:g transform="scale(-1,1)">
                    <svg:path fill="#4161D8" d="M507,253.5c0,140-113.5,253.5-253.5,253.5 S0,393.5,0,253.5S113.5,0,253.5,0S507,113.5,507,253.5z"/>
                    <svg:path  fill="#FFFFFF" d="M97.6,113.6l40.8-47.7c0,0,91.7,3.1,90.6,2.1 c-1.1-1,2.3,89.2,2.3,89.2l-49.8,33.2l-1.1-48.8c0,0-27.2,27-30.6,27c-3.4,0-27.2,61.2-27.2,61.2l-3.4,79.9L67,312.8v-73.6 l10.6-50.5l18.8-34.5l38.5-40.5"/>
                    <svg:path fill="#FFFFFF" d="M459.6,190.5l19.7,59.6 c0,0-50.2,76.9-48.7,76.4c1.5-0.4-77.5-44.3-77.5-44.3l-2.6-59.8l42.3,24.3c0,0-9-37.2-7.2-40.1c1.8-2.9-38.3-54.9-38.3-54.9 l-66.6-44.3l24.3-46.2l63,38.1l37.7,35.3l19.8,34l14.7,53.9"/>
                    <svg:path fill="#FFFFFF" d="M209.2,466.6l-60.7-16.1 c0,0-36.9-84-37.4-82.6c-0.4,1.5,79.4-40.7,79.4-40.7l51.5,30.6l-43.5,22.1c0,0,36.1,12.8,37.6,15.9c1.5,3.1,66.9-2,66.9-2 l73.5-31.5l25.4,45.6l-66.4,31.9l-50.2,12.3l-39.3-2L193,432.9"/>
                </svg:g>
            </svg:symbol>
            
            <svg:symbol id="symbol-roundabout_left" viewBox="253.5 253.5 507 507"> 
                <svg:path fill="#4161D8" d="M507,253.5c0,140-113.5,253.5-253.5,253.5 S0,393.5,0,253.5S113.5,0,253.5,0S507,113.5,507,253.5z"/>
                <svg:path  fill="#FFFFFF" d="M97.6,113.6l40.8-47.7c0,0,91.7,3.1,90.6,2.1 c-1.1-1,2.3,89.2,2.3,89.2l-49.8,33.2l-1.1-48.8c0,0-27.2,27-30.6,27c-3.4,0-27.2,61.2-27.2,61.2l-3.4,79.9L67,312.8v-73.6 l10.6-50.5l18.8-34.5l38.5-40.5"/>
                <svg:path fill="#FFFFFF" d="M459.6,190.5l19.7,59.6 c0,0-50.2,76.9-48.7,76.4c1.5-0.4-77.5-44.3-77.5-44.3l-2.6-59.8l42.3,24.3c0,0-9-37.2-7.2-40.1c1.8-2.9-38.3-54.9-38.3-54.9 l-66.6-44.3l24.3-46.2l63,38.1l37.7,35.3l19.8,34l14.7,53.9"/>
                <svg:path fill="#FFFFFF" d="M209.2,466.6l-60.7-16.1 c0,0-36.9-84-37.4-82.6c-0.4,1.5,79.4-40.7,79.4-40.7l51.5,30.6l-43.5,22.1c0,0,36.1,12.8,37.6,15.9c1.5,3.1,66.9-2,66.9-2 l73.5-31.5l25.4,45.6l-66.4,31.9l-50.2,12.3l-39.3-2L193,432.9"/>
            </svg:symbol>

            <svg:symbol id='symbol-helipad' viewBox="0 0 689.25 581.14">
                <svg:path style="fill:#000000;  fill-rule:nonzero; stroke:none; stroke-width:0.28; stroke-linecap:butt; stroke-linejoin:bevel"
                    d="M 66.47 1.85 C 25.07 2.03 1.85 23.27 1.85 67.01 L 1.85 517.01
                         C 1.85 558.05 22.73 579.29 64.13 579.29 L 515.93 579.29 C 557.33 579.29 578.21 559.13 578.21 517.01
                         L 578.21 67.01 C 578.21 24.35 557.33 2.03 514.67 1.85 C 514.67 1.85 66.29 1.85 66.47 1.85 Z"/>
                <svg:path style="fill:none;  fill-rule:nonzero; stroke:#000000; stroke-width:3.42; stroke-linecap:butt; stroke-linejoin:miter"
                    d="M 66.47 1.85 C 25.07 2.03 1.85 23.27 1.85 67.01 L 1.85 517.01
                         C 1.85 558.05 22.73 579.29 64.13 579.29 L 515.93 579.29 C 557.33 579.29 578.21 559.13 578.21 517.01
                         L 578.21 67.01 C 578.21 24.35 557.33 2.03 514.67 1.85 C 514.67 1.85 66.29 1.85 66.47 1.85"/>
                <svg:path style="fill:#FFFFFF;  fill-rule:nonzero; stroke:none; stroke-width:3.42; stroke-linecap:butt; stroke-linejoin:bevel"
                    d="M 85.91 282.11 C 114.89 282.29 138.29 258.89 138.11 230.09 C 138.29 201.29 114.89 177.89 85.91 177.89
                         C 57.29 177.89 33.89 201.29 33.71 230.09 C 33.89 258.89 57.29 282.29 85.91 282.11 Z"/>
                <svg:path style="fill:#000000;  fill-rule:nonzero; stroke:none; stroke-width:3.42; stroke-linecap:butt; stroke-linejoin:bevel"
                    d="M 85.91 263.21 C 104.45 263.21 119.21 248.45 119.21 230.09 C 119.21 211.73 104.45 196.79 85.91 196.79
                         C 67.73 196.79 52.79 211.73 52.79 230.09 C 52.79 248.45 67.73 263.21 85.91 263.21 Z"/>
                <svg:path style="fill:#FFFFFF;  fill-rule:nonzero; stroke:none; stroke-width:3.42; stroke-linecap:butt; stroke-linejoin:bevel"
                    d="M 253.85 397.31 C 214.07 397.31 214.07 450.95 253.85 450.95 L 484.61 450.95
                         C 523.31 450.95 523.31 397.31 484.61 397.31 L 253.85 397.31 Z"/>
                <svg:polygon style="fill:#FFFFFF;  fill-rule:nonzero; stroke:none; stroke-width:3.42; stroke-linecap:butt; stroke-linejoin:bevel"
                    points="321.89,212.63 321.89,163.85 301.55,163.85 301.55,212.63 
                    321.89,212.63 "/>
                <svg:polygon style="fill:#FFFFFF;  fill-rule:nonzero; stroke:none; stroke-width:3.42; stroke-linecap:butt; stroke-linejoin:bevel"
                    points="353.57,165.11 353.57,154.67 270.41,154.67 270.41,165.11 
                    353.57,165.11 "/>
                <svg:path style="fill:#FFFFFF;  fill-rule:nonzero; stroke:none; stroke-width:3.42; stroke-linecap:butt; stroke-linejoin:bevel"
                    d="M 360.77 147.47 L 493.79 147.47 C 511.61 147.47 511.61 172.85 493.79 172.85
                         L 360.77 172.85 C 343.49 172.85 343.49 147.47 360.77 147.47 Z"/>
                <svg:path style="fill:#FFFFFF;  fill-rule:nonzero; stroke:none; stroke-width:3.42; stroke-linecap:butt; stroke-linejoin:bevel"
                    d="M 130.19 147.47 L 261.77 147.47 C 279.59 147.47 279.59 172.85 261.77 172.85
                         L 130.19 172.85 C 111.47 172.85 111.11 147.47 130.19 147.47 Z"/>
                <svg:path style="fill:#FFFFFF;  fill-rule:nonzero; stroke:none; stroke-width:3.42; stroke-linecap:butt; stroke-linejoin:bevel"
                    d="M 274.55 362.75 C 257.45 362.75 248.99 350.33 246.11 339.71 L 232.79 306.23
                         L 80.69 245.75 C 62.33 238.73 66.83 211.37 87.71 211.37 L 417.83 211.37
                         C 454.55 211.37 475.07 233.51 484.61 256.91 L 511.07 321.35 C 520.61 343.49 504.59 362.75 480.83 362.75
                         L 274.55 362.75 Z"/>
                <svg:polygon style="fill:#000000;  fill-rule:nonzero; stroke:none; stroke-width:3.42; stroke-linecap:butt; stroke-linejoin:bevel"
                    points="357.89,289.13 357.89,232.07 322.25,232.07 322.25,289.13 
                    357.89,289.13 "/>
                <svg:polygon style="fill:#000000;  fill-rule:nonzero; stroke:none; stroke-width:3.42; stroke-linecap:butt; stroke-linejoin:bevel"
                    points="414.23,232.07 414.23,289.13 378.95,289.13 378.95,232.07 
                    414.23,232.07 "/>
                <svg:path style="fill:#000000;  fill-rule:nonzero; stroke:none; stroke-width:3.42; stroke-linecap:butt; stroke-linejoin:bevel"
                    d="M 435.83 234.41 C 446.81 237.11 457.79 247.01 464.99 263.21 L 476.33 289.31
                         L 435.83 289.31 L 435.83 234.41 Z"/>
            </svg:symbol>

            <svg:symbol id="symbol-peak" viewBox="0 0 100 100">
                <svg:path  fill="#d1adc6" stroke="#1f151d" stroke-width="5" d="M 0,90 L 50,10 L 100,90 Z"/>
            </svg:symbol>

            <svg:symbol id="symbol-bus" viewBox="0 0 60 20">
              <svg:g
                  transform="translate(5.7695052,2.8188799e-2)">
                <svg:path
                style="fill:#0000ff;stroke:#000000;stroke-width:0.33102515"
                d="M 2.2521668,0.37432812 C 16.5855,0.37432812 30.918834,0.37432812 45.252168,0.37432812 C 46.355969,1.6734629 46.462793,3.586312 46.948398,5.196193 C 47.576853,8.2837404 48.414233,11.387465 48.252167,14.563593 C 48.236441,15.635583 48.542361,17.557849 46.939414,17.374328 C 32.043665,17.374328 17.147916,17.374328 2.2521668,17.374328 C 0.65875368,17.30455 0.27106428,15.753005 0.2698071,14.227706 C 0.29303084,10.212217 0.1028761,6.2414586 0.23632812,2.1693926 C 0.39484947,1.3347273 1.358163,0.37476685 2.2521668,0.37432812 z " />
                <svg:path
                style="fill:#0000ff;stroke:#ffffff;stroke-width:0.75587374"
                d="M 38.812165,16.734328 C 38.920431,18.865451 36.087926,20.19296 34.514352,18.757021 C 32.815686,17.495237 33.558848,14.486315 35.653279,14.167433 C 37.225591,13.803144 38.854105,15.116219 38.812165,16.734328 z " />
                <svg:path
                style="fill:#0000ff;stroke:#ffffff;stroke-width:0.75587374"
                d="M 15.912166,16.734328 C 16.020431,18.865452 13.187925,20.19296 11.614351,18.757021 C 9.9156863,17.495236 10.658848,14.486315 12.753279,14.167433 C 14.325591,13.803145 15.954103,15.116219 15.912166,16.734328 z " />
                <svg:path
                style="fill:#ffffff;stroke:#000000;stroke-width:0.35478419"
                d="M 36.357025,1.5513395 C 39.305684,1.5513395 40.910594,1.5513395 43.859255,1.5513395 C 44.243739,1.5513395 44.590387,1.6719809 44.715165,1.9230441 C 45.570116,3.6432751 45.6451,5.7562027 46.029437,7.6473997 C 46.245197,8.9459032 46.072777,9.4244981 44.672637,9.4157048 C 41.844185,9.4192225 39.029953,9.3974155 36.281062,9.3974155 C 35.798111,9.3974155 35.537058,8.9607427 35.537058,8.6449215 C 35.562562,6.3521575 35.570716,3.8641786 35.570716,2.2653878 C 35.570716,1.9157124 35.854648,1.5513395 36.357025,1.5513395 z " />
                <svg:rect
                ry="0.60000002"
                y="1.54375"
                x="13.25"
                height="7.875"
                width="10"
                style="fill:#ffffff;fill-opacity:1;stroke:#000000;stroke-width:0.34999999" />
                <svg:rect
                ry="0.60000002"
                y="1.54375"
                x="1.9375"
                height="7.875"
                width="10"
                style="fill:#ffffff;stroke:#000000;stroke-width:0.34999999" />
                <svg:rect
                ry="0.60000002"
                y="1.55"
                x="24.4375"
                height="7.875"
                width="10"
                style="fill:#ffffff;stroke:#000000;stroke-width:0.34999999" />
              </svg:g>
            </svg:symbol>

            <!-- Icon by Josias Polchau: http://j-po.de/download/fussball.svg, cleanup by Knut Arne Bjørndal (Bobkare).
                 Two versions of the icon, the borderless looks better when used for areas -->
            <svg:symbol id="symbol-soccer" viewBox="0 0 300 300">
                <svg:path
                    d="M 138.74616,143.61379 C 138.74616,143.61379 109.59709,168.6577 103.30914,173.40498 C 96.920194,178.22857 93.459587,180.19396 88.308187,174.28928 C 83.233587,168.47274 87.546897,165.90133 92.356387,160.5422 C 97.062964,155.29765 126.64868,128.8279 126.64868,128.8279 L 138.74616,143.61379 z " />
                <svg:path
                    d="M 145.803,151.21693 C 145.803,151.21693 64.746317,251.03849 59.902387,257.44445 C 54.992242,263.93797 56.955466,267.71456 60.932697,270.81067 C 64.818957,273.83606 70.258397,273.0927 74.393827,267.92604 C 78.458207,262.84803 158.70289,162.55321 158.70289,162.55321 L 145.803,151.21693 z " />
                <svg:path
                    style="fill:#000000;"
                    d="M 176.96875 238.12976 A 0.61328125 0.78710938 0 1 1  175.74219,238.12976 A 0.61328125 0.78710938 0 1 1  176.96875 238.12976 z"
                    transform="matrix(26.974199,0,0,21.22496,-4619.7504,-4799.1711)" />
                <svg:path
                    style="fill:#000000;fill-opacity:1;"
                    d="M 162.86792,73.810661 C 182.71632,70.206361 198.86902,68.638661 217.39881,82.508331 L 248.37776,110.06685 C 257.17341,120.77778 257.34762,132.42219 244.07772,139.38463 C 231.42942,146.02091 214.53612,152.724 206.12774,155.37896 C 197.79751,158.00932 193.98122,157.90533 192.86968,152.41453 C 191.76298,146.94765 197.65499,143.56834 203.09835,141.17606 C 208.75019,138.6923 214.2445,137.26621 225.77066,129.97037 C 237.41308,122.6009 233.81653,120.39175 225.24946,113.12886 C 216.61776,105.81117 206.01633,103.64514 199.61271,112.6079 C 190.62693,124.62333 177.01478,146.15042 174.20421,149.64565 C 171.43883,153.08459 168.57247,155.66717 164.30853,153.59661 C 160.0802,151.54333 138.13481,133.95528 135.0829,129.17072 C 132.16792,124.60099 131.91007,123.44358 135.63621,118.30903 C 139.3184,113.23493 147.23184,103.71485 147.23184,103.71485 C 156.94231,91.555571 161.23218,90.026241 143.97429,95.733951 C 126.83389,101.40288 95.624614,111.92225 71.429977,120.33004 C 63.786057,122.48298 60.352877,124.17668 58.269727,117.8216 C 56.135218,111.30982 58.274147,110.46013 65.371177,107.46276 C 72.468207,104.46538 154.37407,75.266611 162.86792,73.810661 z " />
                <svg:path
                    d="M 179.09375 229.38562 A 0.703125 0.6484375 0 1 1  177.6875,229.38562 A 0.703125 0.6484375 0 1 1  179.09375 229.38562 z"
                    transform="matrix(25.017727,0,0,27.127655,-4257.7972,-6173.3124)" />
                <svg:rect
                    style="fill:none;fill-opacity:1;stroke:#000000;stroke-width:15;stroke-linejoin:round;"
                    width="269.39795"
                    height="269.39795"
                    x="15.301026"
                    y="17.663221"
                    ry="21.770645" />
            </svg:symbol>
            <svg:symbol id="symbol-soccer-borderless" viewBox="0 0 300 300">
                <svg:path
                    d="M 138.74616,143.61379 C 138.74616,143.61379 109.59709,168.6577 103.30914,173.40498 C 96.920194,178.22857 93.459587,180.19396 88.308187,174.28928 C 83.233587,168.47274 87.546897,165.90133 92.356387,160.5422 C 97.062964,155.29765 126.64868,128.8279 126.64868,128.8279 L 138.74616,143.61379 z " />
                <svg:path
                    d="M 145.803,151.21693 C 145.803,151.21693 64.746317,251.03849 59.902387,257.44445 C 54.992242,263.93797 56.955466,267.71456 60.932697,270.81067 C 64.818957,273.83606 70.258397,273.0927 74.393827,267.92604 C 78.458207,262.84803 158.70289,162.55321 158.70289,162.55321 L 145.803,151.21693 z " />
                <svg:path
                    style="fill:#000000;"
                    d="M 176.96875 238.12976 A 0.61328125 0.78710938 0 1 1  175.74219,238.12976 A 0.61328125 0.78710938 0 1 1  176.96875 238.12976 z"
                    transform="matrix(26.974199,0,0,21.22496,-4619.7504,-4799.1711)" />
                <svg:path
                    style="fill:#000000;fill-opacity:1;"
                    d="M 162.86792,73.810661 C 182.71632,70.206361 198.86902,68.638661 217.39881,82.508331 L 248.37776,110.06685 C 257.17341,120.77778 257.34762,132.42219 244.07772,139.38463 C 231.42942,146.02091 214.53612,152.724 206.12774,155.37896 C 197.79751,158.00932 193.98122,157.90533 192.86968,152.41453 C 191.76298,146.94765 197.65499,143.56834 203.09835,141.17606 C 208.75019,138.6923 214.2445,137.26621 225.77066,129.97037 C 237.41308,122.6009 233.81653,120.39175 225.24946,113.12886 C 216.61776,105.81117 206.01633,103.64514 199.61271,112.6079 C 190.62693,124.62333 177.01478,146.15042 174.20421,149.64565 C 171.43883,153.08459 168.57247,155.66717 164.30853,153.59661 C 160.0802,151.54333 138.13481,133.95528 135.0829,129.17072 C 132.16792,124.60099 131.91007,123.44358 135.63621,118.30903 C 139.3184,113.23493 147.23184,103.71485 147.23184,103.71485 C 156.94231,91.555571 161.23218,90.026241 143.97429,95.733951 C 126.83389,101.40288 95.624614,111.92225 71.429977,120.33004 C 63.786057,122.48298 60.352877,124.17668 58.269727,117.8216 C 56.135218,111.30982 58.274147,110.46013 65.371177,107.46276 C 72.468207,104.46538 154.37407,75.266611 162.86792,73.810661 z " />
                <svg:path
                    d="M 179.09375 229.38562 A 0.703125 0.6484375 0 1 1  177.6875,229.38562 A 0.703125 0.6484375 0 1 1  179.09375 229.38562 z"
                    transform="matrix(25.017727,0,0,27.127655,-4257.7972,-6173.3124)" />
            </svg:symbol>

            <!-- Icon by Josias Polchau: http://j-po.de/download/tennis.svg, cleanup by Knut Arne Bjørndal (Bobkare).
                 Two versions of the icon, the borderless looks better when used for areas -->
            <svg:symbol id="symbol-tennis" viewBox="0 0 300 300">
              <svg:path
                  d="M 133.48356,82.980553 C 138.35306,72.173033 171.2655,58.800363 192.51384,60.653723 C 213.73985,62.505073 237.71405,63.665993 258.04302,67.164113 C 278.41938,70.670383 273.81866,89.251073 253.94604,86.309203 C 234.07342,83.367333 223.5886,81.516293 212.70243,81.368303 C 201.25474,81.212673 176.06421,83.336283 176.06421,83.336283 C 176.06421,83.336283 209.33859,133.59333 206.51429,141.4943 C 203.49726,149.93472 167.79803,153.18438 164.35398,151.01567 C 159.7332,148.10599 145.81537,122.15035 145.81537,122.15035 C 145.81537,122.15035 145.48073,139.84659 138.26094,148.15246 C 131.2924,156.16936 113.30665,166.08736 93.570228,177.10527 C 74.172798,187.93395 68.917428,170.73223 86.575458,160.96204 C 104.57891,151.00072 110.2885,150.74159 119.77793,136.51374 C 128.44132,123.52437 128.20621,94.692963 133.48356,82.980553 z " />
              <svg:path
                  transform="matrix(9.1042659,1.3880946,-1.3880946,9.1042659,-4261.6122,-3496.328)"
                  d="M 533.25 308.01843 A 1.96875 2.03125 0 1 1  529.3125,308.01843 A 1.96875 2.03125 0 1 1  533.25 308.01843 z" />
              <svg:path
                  style="fill:none;stroke:#000000;stroke-width:1;stroke-linejoin:miter;stroke-miterlimit:4"
                  d="M 523.25 317.36218 A 2.21875 3.4375 0 1 1  518.8125,317.36218 A 2.21875 3.4375 0 1 1  523.25 317.36218 z"
                  transform="matrix(8.5738824,-3.3619914,3.3619914,8.5738824,-5484.0276,-867.36526)" />
              <svg:path
                  style="fill:none;stroke:#000000;stroke-width:11;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4"
                  d="M 62.035328,130.7928 L 83.309188,176.55851 L 83.309188,176.55851" />
              <svg:path
                  d="M 167.88902,179.26882 C 174.63629,196.08176 185.51796,222.30373 191.27971,235.00091 C 197.81276,249.42148 216.58336,244.48335 209.90891,229.13702 C 203.29399,213.92749 192.40258,190.93014 185.66274,173.99209 C 179.80977,159.28237 161.65625,163.73783 167.88902,179.26882 z " />
              <svg:path
                  d="M 193.27277,162.52913 C 189.19197,155.01532 206.63644,152.75805 209.97627,158.98654 C 213.27965,165.14706 256.36141,243.72038 263.82444,258.19246 C 271.28994,272.66912 252.41266,278.68635 246.02367,265.48633 C 239.98905,253.01845 197.45908,170.23721 193.27277,162.52913 z " />
              <svg:rect
                  style="fill:none;stroke:#000000;stroke-width:15;stroke-linejoin:round;"
                  width="269.39795"
                  height="269.39795"
                  x="14.29852"
                  y="16.102072"
                  ry="21.770645" />
            </svg:symbol>
            <svg:symbol id="symbol-tennis-borderless" viewBox="0 0 300 300">
              <svg:path
                  d="M 133.48356,82.980553 C 138.35306,72.173033 171.2655,58.800363 192.51384,60.653723 C 213.73985,62.505073 237.71405,63.665993 258.04302,67.164113 C 278.41938,70.670383 273.81866,89.251073 253.94604,86.309203 C 234.07342,83.367333 223.5886,81.516293 212.70243,81.368303 C 201.25474,81.212673 176.06421,83.336283 176.06421,83.336283 C 176.06421,83.336283 209.33859,133.59333 206.51429,141.4943 C 203.49726,149.93472 167.79803,153.18438 164.35398,151.01567 C 159.7332,148.10599 145.81537,122.15035 145.81537,122.15035 C 145.81537,122.15035 145.48073,139.84659 138.26094,148.15246 C 131.2924,156.16936 113.30665,166.08736 93.570228,177.10527 C 74.172798,187.93395 68.917428,170.73223 86.575458,160.96204 C 104.57891,151.00072 110.2885,150.74159 119.77793,136.51374 C 128.44132,123.52437 128.20621,94.692963 133.48356,82.980553 z " />
              <svg:path
                  transform="matrix(9.1042659,1.3880946,-1.3880946,9.1042659,-4261.6122,-3496.328)"
                  d="M 533.25 308.01843 A 1.96875 2.03125 0 1 1  529.3125,308.01843 A 1.96875 2.03125 0 1 1  533.25 308.01843 z" />
              <svg:path
                  style="fill:none;stroke:#000000;stroke-width:1;stroke-linejoin:miter;stroke-miterlimit:4"
                  d="M 523.25 317.36218 A 2.21875 3.4375 0 1 1  518.8125,317.36218 A 2.21875 3.4375 0 1 1  523.25 317.36218 z"
                  transform="matrix(8.5738824,-3.3619914,3.3619914,8.5738824,-5484.0276,-867.36526)" />
              <svg:path
                  style="fill:none;stroke:#000000;stroke-width:11;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4"
                  d="M 62.035328,130.7928 L 83.309188,176.55851 L 83.309188,176.55851" />
              <svg:path
                  d="M 167.88902,179.26882 C 174.63629,196.08176 185.51796,222.30373 191.27971,235.00091 C 197.81276,249.42148 216.58336,244.48335 209.90891,229.13702 C 203.29399,213.92749 192.40258,190.93014 185.66274,173.99209 C 179.80977,159.28237 161.65625,163.73783 167.88902,179.26882 z " />
              <svg:path
                  d="M 193.27277,162.52913 C 189.19197,155.01532 206.63644,152.75805 209.97627,158.98654 C 213.27965,165.14706 256.36141,243.72038 263.82444,258.19246 C 271.28994,272.66912 252.41266,278.68635 246.02367,265.48633 C 239.98905,253.01845 197.45908,170.23721 193.27277,162.52913 z " />
            </svg:symbol>

            <!-- Icon by Josias Polchau: http://j-po.de/download/schwimmen.svg, cleanup by Knut Arne Bjørndal (Bobkare).
                 Two versions of the icon, the borderless looks better when used for areas -->
            <svg:symbol id="symbol-swimming" viewBox="0 0 300 300">
              <svg:path
                  d="M 210.53915,180.45818 C 221.18483,180.42063 228.59512,160.17099 250.83602,160.44974 C 273.582,160.72849 276.4272,177.41436 290.76227,177.7222 C 290.68595,187.3812 290.75823,185.21412 290.83303,193.87816 C 270.18685,193.40007 268.0079,172.81556 251.07545,173.33716 C 234.32157,173.85876 230.97744,194.56702 211.28145,194.18182 C 191.40689,193.79662 189.17993,173.19882 168.67447,173.10386 C 147.99044,173.00889 142.97677,193.08728 125.06307,193.36288 C 120.39415,193.24116 116.11472,191.54501 112.08545,189.20714 C 102.30978,183.53507 94.006659,174.08564 85.186335,174.17905 C 72.729891,174.31098 61.09516,190.45637 45.663964,190.6261 C 30.613903,190.79068 24.262669,177.90922 16.243098,177.92116 C 16.330948,168.99273 16.146328,170.51037 16.0949,162.12021 C 30.018485,162.41604 36.756221,175.52218 44.709562,175.70947 C 52.752189,175.89677 71.586801,159.33619 81.451947,159.44526 C 91.315702,159.55432 96.825144,160.05397 105.80266,166.84009 C 122.39809,159.11328 155.04728,141.99864 155.67088,140.85475 C 160.58076,131.84835 156.09627,109.8996 140.93062,105.9839 C 125.93231,102.11141 98.315313,111.19762 78.932923,114.42935 C 59.626217,117.64846 56.387347,102.77595 73.838857,95.61157 C 91.538773,88.3452 117.48654,82.076364 137.70712,78.24353 C 157.8058,74.433803 160.83707,80.588591 163.77824,86.63543 C 166.76917,92.784581 203.28035,176.19322 203.28035,176.19322 C 206.63143,179.44496 207.56153,180.46846 210.53915,180.45818 z "
                  />
              <svg:path
                  style="stroke:#000000;stroke-width:21;stroke-linejoin:miter;stroke-miterlimit:4"
                  d="M 371.07143 260.39789 A 18.571428 22.678572 0 1 1  333.92857,260.39789 A 18.571428 22.678572 0 1 1  371.07143 260.39789 z"
                  transform="matrix(1.040898,0,0,0.8287669,-145.29268,-80.9236)"
                  />
              <svg:rect
                  style="fill:none;stroke:#000000;stroke-width:15;stroke-linejoin:round;stroke-miterlimit:4"
                  width="269.39795"
                  height="269.39795"
                  x="16.816265"
                  y="17.104565"
                  ry="21.770645" />
            </svg:symbol>
            <svg:symbol id="symbol-swimming-borderless" viewBox="0 0 300 300">
              <svg:path
                  d="M 210.53915,180.45818 C 221.18483,180.42063 228.59512,160.17099 250.83602,160.44974 C 273.582,160.72849 276.4272,177.41436 290.76227,177.7222 C 290.68595,187.3812 290.75823,185.21412 290.83303,193.87816 C 270.18685,193.40007 268.0079,172.81556 251.07545,173.33716 C 234.32157,173.85876 230.97744,194.56702 211.28145,194.18182 C 191.40689,193.79662 189.17993,173.19882 168.67447,173.10386 C 147.99044,173.00889 142.97677,193.08728 125.06307,193.36288 C 120.39415,193.24116 116.11472,191.54501 112.08545,189.20714 C 102.30978,183.53507 94.006659,174.08564 85.186335,174.17905 C 72.729891,174.31098 61.09516,190.45637 45.663964,190.6261 C 30.613903,190.79068 24.262669,177.90922 16.243098,177.92116 C 16.330948,168.99273 16.146328,170.51037 16.0949,162.12021 C 30.018485,162.41604 36.756221,175.52218 44.709562,175.70947 C 52.752189,175.89677 71.586801,159.33619 81.451947,159.44526 C 91.315702,159.55432 96.825144,160.05397 105.80266,166.84009 C 122.39809,159.11328 155.04728,141.99864 155.67088,140.85475 C 160.58076,131.84835 156.09627,109.8996 140.93062,105.9839 C 125.93231,102.11141 98.315313,111.19762 78.932923,114.42935 C 59.626217,117.64846 56.387347,102.77595 73.838857,95.61157 C 91.538773,88.3452 117.48654,82.076364 137.70712,78.24353 C 157.8058,74.433803 160.83707,80.588591 163.77824,86.63543 C 166.76917,92.784581 203.28035,176.19322 203.28035,176.19322 C 206.63143,179.44496 207.56153,180.46846 210.53915,180.45818 z "
                  />
              <svg:path
                  style="stroke:#000000;stroke-width:21;stroke-linejoin:miter;stroke-miterlimit:4"
                  d="M 371.07143 260.39789 A 18.571428 22.678572 0 1 1  333.92857,260.39789 A 18.571428 22.678572 0 1 1  371.07143 260.39789 z"
                  transform="matrix(1.040898,0,0,0.8287669,-145.29268,-80.9236)"
                  />
            </svg:symbol>

            <svg:symbol id="toilets" viewBox="0 0 200 200">
                <svg:rect style="fill:#0087ff;fill-opacity:1" 
                    width="200" 
                    height="200" 
                    x="0" 
                    y="0" 
                    rx="40" 
                    ry="40"
                />
                <svg:rect
                    style="fill:#ffffff;stroke:#ffffff;stroke-width:5px;stroke-linejoin:round;stroke-opacity:1"
                    y="30.489416"
                    x="100.1455"
                    height="141.07143"
                    width="11.428572" 
                    />
                <svg:path
                    style="fill:#ffffff;stroke:#ffffff;stroke-opacity:1"
                    d="M 162.85978,41.739417 C 162.85978,48.366834 157.4872,53.739417 150.85978,53.739417 C 144.23236,53.739417 138.85978,48.366834 138.85978,41.739417 C 138.85978,35.112 144.23236,29.739417 150.85978,29.739417 C 157.4872,29.739417 162.85978,35.112 162.85978,41.739417 L 162.85978,41.739417 z "
                    />
                <svg:path
                    style="fill:#ffffff;stroke:#ffffff;stroke-linejoin:round;stroke-opacity:1"
                    d="M 69.645503,42.989417 C 69.645503,49.616834 64.27292,54.989417 57.645503,54.989417 C 51.018086,54.989417 45.645503,49.616834 45.645503,42.989417 C 45.645503,36.362 51.018086,30.989417 57.645503,30.989417 C 64.27292,30.989417 69.645503,36.362 69.645503,42.989417 z "
                    />
                <svg:path
                    style="fill:#ffffff;fill-rule:evenodd;stroke:#ffffff;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:round;stroke-opacity:1"
                    d="M 54.920897,128.44734 L 59.466584,128.44734 L 60.224198,168.6009 L 67.547804,168.6009 L 68.305419,128.1948 L 80.427249,127.94226 L 67.295266,79.707479 L 70.8308,77.687174 L 81.437402,112.53743 L 89.266084,108.24428 L 73.356181,61.777271 L 41.283838,60.767119 L 24.868859,109.25444 L 31.939927,112.03236 L 43.556681,77.687174 L 46.839677,78.19225 L 33.707694,127.43718 L 44.819372,127.68972 L 46.334601,168.85344 L 53.658207,168.85344 L 54.920897,128.44734 z "
                    />
                <svg:path
                    style="fill:#ffffff;fill-rule:evenodd;stroke:#ffffff;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:round;stroke-opacity:1;fill-opacity:1"
                    d="M 133.96533,60.514581 L 164.77498,60.262042 L 174.87651,68.090725 L 176.64428,113.29505 L 167.80544,113.04251 L 166.79529,77.182098 L 162.2496,76.677021 L 162.37587,168.97971 L 153.91584,169.23224 L 152.14808,114.3052 L 147.85493,114.05266 L 146.84478,169.61105 L 139.01609,169.10598 L 138.51102,77.434636 L 133.71279,77.434636 L 134.21787,112.53743 L 125.63157,112.78997 L 124.87396,68.595801 L 133.96533,60.514581 z "
                    />
                </svg:symbol>     		
                <svg:symbol id="information" viewBox="0 0 200 200">
                    <svg:rect
                style="fill:#0087ff;fill-opacity:1"
                width="200"
                height="200"
                x="0"
                y="0"
                rx="40"
                ry="40"
                    />
                <svg:path
                style="fill:#ffffff;fill-opacity:1;fill-rule:evenodd"
                    d="M 114.9996,71.691476 L 114.9996,160.4199 L 126.82978,160.4199 L 126.82978,170.98263 L 124.71757,170.98263 L 73.170217,170.98263 L 73.170217,160.4199 L 85.000937,160.4199 L 85.000937,82.254149 L 73.170217,82.254149 L 73.170217,71.691412 L 75.282973,71.691412 L 114.99957,71.691412 L 114.9996,71.691476 z M 84.155594,43.805631 C 84.155594,40.002758 85.529241,36.587522 88.275447,33.559351 C 91.021656,30.531181 94.578158,29.017365 98.943844,29.017365 L 101.0566,29.017365 C 104.71822,29.017365 108.09842,30.35543 111.19668,33.031558 C 114.29548,35.707143 115.84433,39.29868 115.84433,43.805631 C 115.84433,47.607949 114.5068,51.023202 111.83067,54.051372 C 109.15455,57.079542 105.56355,58.593358 101.0566,58.593358 L 98.943844,58.593358 C 95.28222,58.593358 91.902019,57.255293 88.803763,54.579704 C 85.704967,51.90358 84.155578,48.312043 84.155578,43.805631 L 84.155594,43.805631 z "
                    />
            </svg:symbol>

    </xsl:template>
</xsl:stylesheet>

