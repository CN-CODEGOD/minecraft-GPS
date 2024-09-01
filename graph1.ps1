. $PSScriptRoot\gps.class.ps1
. $PSScriptRoot\graph.class.ps1
. $PSScriptRoot\bellman-ford.ps1


function graph {
    param (
        
    [place]$myplace
    ,
    [place]$destination
    ,
    [dimension]$dimension

)


$roads=import-Clixml $PSScriptRoot\xml\roads.xml|Where-Object {$_.dimension -like $dimension}
$graph = New-Object Graph
$vertexO=new-object vertex $myplace
$vertexA=New-Object Vertex $ROADS[0]
$vertexB=New-Object Vertex $ROADS[1]
$vertexC=New-Object Vertex $ROADS[2]
$vertexD=New-Object Vertex $ROADS[3]
$vertexE=New-Object Vertex $ROADS[4]
$vertexP=New-Object Vertex $destination
$O=$myplace
$A=$roadS[0]
$B=$ROADS[1]
$C=$ROADS[2]
$D=$ROADS[3]
$E=$ROADS[4]
$P=$destination

#O
$weightOA=[ROAD]::calcroute($O,$A)
$weightOB=[ROAD]::calcroute($O,$B)
$weightOC=[ROAD]::calcroute($O,$C)
$weightOD=[ROAD]::calcroute($O,$D)
$weightOE=[ROAD]::calcroute($O,$E)
$weightOP=[ROAD]::calcroute($O,$P)
#A
$weightAB=[ROAD]::calcroute($A,$B)
$weightAC=[ROAD]::calcroute($A,$C)
$weightAD=[ROAD]::calcroute($A,$D)
$weightAE=[ROAD]::calcroute($A,$E)
$weightAP=[ROAD]::calcroute($A,$P)
#B
$weightBC=[ROAD]::calcroute($B,$C)
$weightBD=[ROAD]::calcroute($B,$D)
$weightBE=[ROAD]::calcroute($B,$E)
$weightBP=[ROAD]::calcroute($B,$P)
#C
$weightCD=[ROAD]::calcroute($C,$D)
$weightCE=[ROAD]::calcroute($C,$e)
$weightCP=[ROAD]::calcroute($C,$P)
#D
$weightDE=[ROAD]::calcroute($D,$E)
$weightDP=[ROAD]::calcroute($D,$P)
#E
$weightEP=[ROAD]::calcroute($E,$P)
#O
$edgeOA = [edge]::new($vertexO,$vertexA,$weightOA)
$edgeOB = New-Object EDGE $vertexO,$vertexB,$weightOB
$edgeOC = New-Object EDGE $vertexO,$vertexC,$weightOC
$edgeOD = New-Object EDGE $vertexO,$vertexD,$weightOD
$edgeOE = New-Object EDGE $vertexO,$vertexE,$weightOE
$edgeOP = New-Object EDGE $vertexO,$vertexP,$weightOP
#A
$edgeAB=New-Object EDGE $vertexA,$vertexB,$weightAB
$edgeAC=New-Object EDGE $vertexA,$vertexC,$weightAC
$edgeAD=New-Object EDGE $vertexA,$vertexD,$weightAD
$edgeAE=New-Object EDGE $vertexA,$vertexE,$weightAE
$edgeAP=New-Object EDGE $vertexA,$vertexP,$weightAP
#B
$edgeBC=New-Object EDGE $verteXB,$vertexC,$weightBC
$edgeBD=New-Object EDGE $vertexB,$vertexD,$weightBD
$edgeBE=New-Object EDGE $vertexB,$vertexE,$weightBE
$edgeBP=New-Object EDGE $vertexB,$vertexP,$weightBP
#C
$edgeCD=New-Object EDGE $vertexC,$vertexD,$weightCD
$edgeCE=New-Object EDGE $vertexC,$vertexE,$weightCE
$edgeCP=New-Object EDGE $vertexC,$vertexP,$weightCP
#D
$edgeDE=New-Object EDGE $vertexD,$vertexE,$weightDE
$edgeDP=New-Object EDGE $vertexD,$vertexP,$weightDP
#E
$edgeEP=New-Object EDGE $vertexE,$vertexP,$weightEP
#O
$GRAPH.addEdge($edgeOA)
$GRAPH.addEdge($edgeOB)
$GRAPH.addEdge($edgeOC)
$GRAPH.addEdge($edgeOD)
$GRAPH.addEdge($edgeOE)
$GRAPH.addEdge($edgeOP)
#A
$GRAPH.addEdge($edgeAB)
$GRAPH.addEdge($edgeAC)
$GRAPH.addEdge($edgeAD)
$GRAPH.addEdge($edgeAE)
$GRAPH.addEdge($edgeAP)
#B
$GRAPH.addEdge($edgeBC)
$GRAPH.addEdge($edgeBD)
$GRAPH.addEdge($edgeBE)
$GRAPH.addEdge($edgeBP)
#C
$GRAPH.addEdge($edgeCD)
$GRAPH.addEdge($edgeCE)
$GRAPH.addEdge($edgeCP)
#D
$GRAPH.addEdge($edgeDE)
$GRAPH.addEdge($edgeDP)
#E
$GRAPH.addEdge($edgeEP)
$GRAPH
}
