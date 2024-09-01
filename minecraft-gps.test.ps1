import-Module "C:\Users\34683\BFS\minecraft-GPS.PSM1" -WarningAction Ignore
. $PSScriptRoot\graph.class.ps1
. $PSScriptRoot\graph.ps1
. $PSScriptRoot\gps.class.ps1
. $PSScriptRoot\bellman-ford

describe 'TEST gps.psm1'{

    beforeAll {

        $road=[road]([pscustomobject]@{
    

    
roadcoordinate=[pscustomobject]@{
roadcoordinate1=[pscustomobject]@{
x=1
y=1
z=1}
roadcoordinate2=[pscustomobject]@{
x=2
y=1
z=2}}
id=0
})
        $mycoordinate=[System.Numerics.Vector3]::new(1,2,3)
        $placecoordinate=[System.Numerics.Vector3]::new(50,50,50)
        $wynncraft_place=[wynncraft_place]([pscustomobject]@{
            placecoordinate=[pscustomobject]@{
                x=800
                y=60
                z=500
            }
            id='0'
            type='bank'

        })
        $survival_place=[survival_place]([pscustomobject@{
            placecoordinate=[pscustomobject]@{
                x=800
                y=60
                z=500
            }
            type= 'nether_portal'
            id=0
            dimension='nether'
        }])



    }
<#    context 'main class test'{
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
            $length+= [main]::calc($currentNode,$currentNode.next)
        } while (
            $currentNode
        )
        }
        
        }#>

context 'search-place'{
    it 'wynncraft_place'{
search-place -wynncraft_place $wynncraft_place -mycoordinate $mycoordinate
    }
    it 'survival_place'{
search-place -survival_place  $survival_place -mycoordinate $mycoordinate
    }
    it 'road'{
search-place -road $road -mycoordinate $mycoordinate
    }
it 'teleportation_place'{
    search-place -teleportation_place $teleportation_place $mycoordinate $mycoordinate
}

}
context 'find-place'{
it 'survival_place'{
find-place -survival_place $survival_place
}
it 'wynncraft_place'{
find-place -wynncraft_place $wynncraft_place
}
it 'road'{
find-place -road $road
}
it  'teleportation_place'{
find-place -teleportation_place $teleportation_place
}
}
context 'add-place'{
 it 'survival_place'{
add-place -survival_place $survival_place
}
it 'wynncraft_place'{
add-place -wynncraft_place $wynncraft_place
}
it 'road'{
add-place -road $road
}
it  'teleportation_place'{
add-place -teleportation_place $teleportation_place
}
}
context 'road-route'{
road-route -road $road -destination $placecoordinate -mycoordinate $mycoordinate
}
context'teleportation_route'{


}
context 'remove-place'{
    it 'road'{
remove-place -road 1
    }
    it 'survival_place'{
remove-place -survival_place 1
    }
    it 'wynncraft_place'{
remove-place -wynncraft_place 1
    }
    it 'teleportation_place'{
remove-place -teleportation_place 1
    }
}
}

