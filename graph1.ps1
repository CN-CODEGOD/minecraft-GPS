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


$roads=import-xml $PSScriptRoot\xml\roads.xml|Where-Object {$_.dimension -like $dimension}
$graph = New-Object Graph
$vertexO=new-object vertex $myplace
$vertexA=New-Object Vertex $ROADS[0]
$vertexB=New-Object Vertex $ROADS[1]
$vertexC=New-Object Vertex $ROADS[2]
$vertexD=New-Object Vertex $ROADS[3]

$vertexP=New-Object Vertex $destination
$O=$myplace
$A=$roadS[0]
$B=$ROADS[1]
$C=$ROADS[2]
$D=$ROADS[3]

$P=$destination

#O
$weightOA=[ROAD]::calcroute($O,$A)
$weightOB=[ROAD]::calcroute($O,$B)
$weightOC=[ROAD]::calcroute($O,$C)
$weightOD=[ROAD]::calcroute($O,$D)

$weightOP=[ROAD]::calcroute($O,$P)
#A
$weightAB=[ROAD]::calcroute($A,$B)
$weightAC=[ROAD]::calcroute($A,$C)
$weightAD=[ROAD]::calcroute($A,$D)

$weightAP=[ROAD]::calcroute($A,$P)
#B
$weightBC=[ROAD]::calcroute($B,$C)
$weightBD=[ROAD]::calcroute($B,$D)

$weightBP=[ROAD]::calcroute($B,$P)
#C
$weightCD=[ROAD]::calcroute($C,$D)

$weightCP=[ROAD]::calcroute($C,$P)
#D

$weightDP=[ROAD]::calcroute($D,$P)
#E

#O
$edgeOA = [edge]::new($vertexO,$vertexA,$weightOA)
$edgeOB = New-Object EDGE $vertexO,$vertexB,$weightOB
$edgeOC = New-Object EDGE $vertexO,$vertexC,$weightOC
$edgeOD = New-Object EDGE $vertexO,$vertexD,$weightOD

$edgeOP = New-Object EDGE $vertexO,$vertexP,$weightOP
#A
$edgeAB=New-Object EDGE $vertexA,$vertexB,$weightAB
$edgeAC=New-Object EDGE $vertexA,$vertexC,$weightAC
$edgeAD=New-Object EDGE $vertexA,$vertexD,$weightAD

$edgeAP=New-Object EDGE $vertexA,$vertexP,$weightAP
#B
$edgeBC=New-Object EDGE $verteXB,$vertexC,$weightBC
$edgeBD=New-Object EDGE $vertexB,$vertexD,$weightBD

$edgeBP=New-Object EDGE $vertexB,$vertexP,$weightBP
#C
$edgeCD=New-Object EDGE $vertexC,$vertexD,$weightCD

$edgeCP=New-Object EDGE $vertexC,$vertexP,$weightCP
#D

$edgeDP=New-Object EDGE $vertexD,$vertexP,$weightDP
#E

#O
$GRAPH.addEdge($edgeOA)
$GRAPH.addEdge($edgeOB)
$GRAPH.addEdge($edgeOC)
$GRAPH.addEdge($edgeOD)

$GRAPH.addEdge($edgeOP)
#A
$GRAPH.addEdge($edgeAB)
$GRAPH.addEdge($edgeAC)
$GRAPH.addEdge($edgeAD)

$GRAPH.addEdge($edgeAP)
#B
$GRAPH.addEdge($edgeBC)
$GRAPH.addEdge($edgeBD)

$GRAPH.addEdge($edgeBP)
#C
$GRAPH.addEdge($edgeCD)

$GRAPH.addEdge($edgeCP)
#D

$GRAPH.addEdge($edgeDP)
#E

$GRAPH
}
$example_place1 = [place]::new(([System.Numerics.Vector3]::new(1,2,-100)),"o")
$example_place2= [place]::new(([System.Numerics.Vector3]::new(4,5,100)),"P")

graph -myplace $example_place1 -destination $example_place2 -dimension "nether" 