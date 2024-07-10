. $PSScriptRoot\gps.class.ps1
. $PSScriptRoot\graph.class.ps1
. $PSScriptRoot\graph.ps1
. $PSScriptRoot\bellman-ford.ps1
    
describe 'TEST gps.psm1'{
    context 'main class test'{
        it 'test lineintersect'{
            

            $road1 =(import-Clixml c:\ex-sys\xml\roads.xml)[1]
            $road2 = (import-Clixml c:\ex-sys\xml\roads.xml)[2]
            $lineIntersect =  [main]::lineIntersect($road1.roadcoordinate,$road2.roadcoordinate)
            $lineIntersect.x|should not be $null
            $lineIntersect.x.gettype()|should not be int
            $lineIntersect.y|should not be $null
            $lineIntersect.y.gettype()|should not be int
        }
        it 'test inline'{
            $road1 =(import-Clixml c:\ex-sys\xml\roads.xml)[1]
            $road2 = (import-Clixml c:\ex-sys\xml\roads.xml)[2]
            [main]::inline($road1,$road2)|should be $false
        }
    }
    context 'GPS find road' { 
        it 'trouble shooting the  graph weight ' {
            $roads=import-Clixml c:\ex-sys\xml\roads.xml
            $placecoordinate=[placecoordinate](1,2,3)
            
            $endVertex = New-Object vertex $roads[1]
            $endVertex.value.roadcoordinate|should not be $null
            [road]::calcroute($startVertex.value,$endVertex.value)
            $vertexO=New-Object Vertex $PLACEcoordinate
            $vertexA=New-Object vertex $roads[0]
            $vertexB=New-Object vertex $roads[1]
            $edgeAB=New-Object EDGE $vertexA,$vertexB
            $edgeOA=New-Object EDGE $vertexO,$vertexA
            $graph.addedge($edgeAB)
            $graph.addedge($edgeOA)
        }
        
        
        it 'test calc route'{
        
            $roads=import-Clixml "C:\ex-sys\xml\roads.xml"
            $placecoordinate=[placecoordinate](1,2,3)
            $road4=$roads|Where-Object{$_.id -eq 4}
            $road5=$roads|Where-Object{$_.id -eq 5}
            [road]::calcroute($placecoordinate,$road4)
            [road]::calcroute($road5,$road4)
            $placecoordinate=[placecoordinate](100,0,100)
            [road]::calcroute($placecoordinate,$road4)
        }
        
        
        it 'get the target road by id'{
            $mycoordinate= [placecoordinate](1,2,3)
            $graph = graph $mycoordinate
            $targetVetex  = $graph.getvertexById(4)
            $paths= bellman-ford $graph 
            $previousVertices =$paths[1]
            $previousVertices[$targetVetex]|should not be $null

        
        }
        it ' get route' {
            $placecoordinate=[PLACEcoordinate](100,0,100);$graph=graph $placecoordinate;$paths=bellman-ford $graph
            $targetVetex  = $graph.getvertexById(4)
            $startVertex = $graph["O"]
            $previousVertices= $paths[1]
          
        }

        it ' get length' {
            $mycoordinate= [placecoordinate](1,2,3)
            $graph = graph $mycoordinate
            
            $paths= bellman-ford $graph 
            $roadroute = New-Object System.Collections.Generic.LinkedList
            $currentNode = $roadroute
        do {
            
            $currentNode  = $currentNode.next
            $currentNode.gettype()|should be "placecoordinate"
            $length+= [main]::calc($currentNode,$currentNode.previous)
        } while (
            $currentNode
        )
        }
        
        }
}

