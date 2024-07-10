
. $PSScriptRoot\graph.class.ps1


function graph {
    param (
        $mycoordinate
    
        ,
        $destination

    )
     

$roads=import-Clixml "C:\ex-sys\xml\roads.xml"
$graph = New-Object Graph
$vertexO=New-Object Vertex $mycoordinate
$vertexA=New-Object vertex $roads[0]
$vertexB=New-Object vertex $roads[1]
$vertexC=New-Object vertex $roads[2]
$vertexD=New-Object vertex $roads[3]
$vertexE=New-Object vertex $roads[4]
$vertexF= New-Object Vertex $roads[5]
$vertexG= New-Object Vertex $roads[6]
$PLACEcoordinate.id = "P"
$vertexP= New-Object Vertex $placecoordinate

#O
$edgeOA=New-Object edge $vertexO,$vertexA
$edgeOB=New-Object edge $vertexO,$vertexB
$edgeOC=New-Object edge $vertexO,$vertexC
$edgeOD=New-Object edge $vertexO,$vertexD
$edgeOE=New-Object edge $vertexO,$vertexE
$edgeOF=New-Object EDGE $vertexO,$vertexF
$edgeOG=New-Object edge $vertexO,$vertexG
$edgeOP=New-Object edge $vertexO,$vertexP


#A
$edgeAB = New-Object edge $vertexA,$vertexB
$edgeAD = New-Object edge $vertexA,$vertexD
$edgeAC=New-Object edge $vertexA,$vertexC
$edgeAE=New-Object edge $vertexA,$vertexE
$edgeAF=New-Object edge $vertexA,$vertexF
$edgeAG=New-Object edge $vertexA,$vertexG
$edgeAP=New-Object EDGE $vertexA,$vertexP

#B
$edgeBC=New-Object edge $vertexB,$vertexc 
$edgeBD=New-Object edge $vertexB,$vertexD
$edgeBE=New-Object edge $vertexB,$vertexE
$edgeBF=New-Object edge $vertexB,$vertexF
$edgeBG=New-Object edge $vertexB,$vertexG
$edgeBP=New-Object edge $vertexB,$vertexP

#C
$edgecd =New-Object edge $vertexC,$vertexD
$edgeCE=New-Object EDGE $vertexC,$vertexE
$edgeCF =New-Object edge $vertexC,$vertexF
$edgeCG =New-Object edge $vertexC,$vertexG
$edgeCP=New-Object edge $vertexC,$vertexP
#D
$edgeDE=New-Object EDGE $vertexD,$vertexE
$edgeDF=New-Object EDGE $vertexD,$vertexF
$edgeDG=New-Object EDGE $vertexD,$vertexG
$edgeDP=New-Object edge $vertexD,$vertexP

#E
$edgeEF=New-Object EDGE $vertexE,$vertexF
$edgeEG=New-Object EDGE $vertexE,$vertexG
$edgeEP=New-Object EDGE $vertexE,$vertexP

#F
$edgeFG=New-Object EDGE $vertexF,$vertexG
$edgeFP=New-Object EDGE $vertexF,$vertexP
#G
$edgeGP=New-Object EDGE $vertexG,$vertexP

$graph.addEdge($edgeOA)
$graph.addEdge($edgeOB)
$graph.addEdge($edgeOC)
$graph.addEdge($edgeOD)
$graph.addEdge($edgeOE)
$graph.addEdge($edgeOF)
$graph.addEdge($edgeOG)
$graph.addedge($edgeOP)

#A
$graph.addEdge($edgeAB)       
$graph.addEdge($edgeAD)
$graph.addEdge($edgeAC)
$graph.addEdge($edgeAE)
$graph.addEdge($edgeAF)
$graph.addEdge($edgeAG)
$graph.addedge($edgeAP)

#B
$graph.addedge($edgeBC)
$graph.addedge($edgeBD)
$graph.addedge($edgeBE)
$graph.addedge($edgeBF)
$graph.addedge($edgeBG)
$graph.addedge($edgeBP)

#C
$graph.addedge($edgeCD)
$graph.addedge($edgeCE)
$graph.addedge($edgeCF)
$graph.addedge($edgeCG)
$graph.addEdge($edgeCP)
#D
$graph.addedge($edgeDE)
$graph.addedge($edgeDF)
$graph.addedge($edgeDG)
$graph.addedge($edgeDP)
#E
$graph.addedge($edgeEF)
$graph.addedge($edgeEG)
$graph.addedge($edgeEP)
#F
$graph.addedge($edgeFG)
$graph.addEdge($edgeFP)
#G
$graph.addedge($edgeGP)

$graph


}
    