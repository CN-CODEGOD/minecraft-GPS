. $PSScriptRoot\gps.class.ps1
. $PSScriptRoot\graph1.ps1
. $PSScriptRoot\graph.class.ps1
. $PSScriptRoot\bellman-ford.ps1


describe 'graph'{


    context 'graph '{



        it 'test the graph function'{
            <#the_end
            $mycoordinate =[place]::new((1,2,3))
            $placecoordinate = [place]::new((500,0,-1000),"p")
            $graph=graph $mycoordinate $placecoordinate ""
            $graph |should not be $null 
            
            $graph.vertices.Values|should not be $null  #>
            #nether
            $mycoordinate =[place]::new((1,2,3))
            $placecoordinate = [place]::new((500,0,-1000),"p")
            $graph=graph $mycoordinate $placecoordinate "nether"
            $graph |should not be $null 
            $vertex=$graph.getVertexByKey("p")
            
            $neighbors= $graph.getNeighbors($vertex)
            $neighbors[0].edges|should not be $null
            $neighbors[1].edges|should not be $null
            $neighbors[2].edges|should not be $null
            $neighbors[3].edges|should not be $null
            $neighbors[4].edges|should not be $null
            $neighbors[5].edges|should not be $null


            $graph.vertices.Values|should not be $null  
        }
     
         it 'test enqueue' { 

$myplace=[place]::new((1,2,3))                
$roads=import-Clixml C:\Users\34683\bfs\xml\roads.xml|Where-Object {$_.dimension -like "nether"}

$roadsqueue= New-Object System.Collections.Generic.Queue[object]
$roadsqueue.enqueue($myplace)
foreach ($road in $roads) { 
    $roadsqueue.enqueue($road)

}
$roadsqueue.Count | Should BE 6
         }

         IT 'TEST weight' {

            $roads=import-Clixml C:\Users\34683\bfs\xml\roads.xml|Where-Object {$_.dimension -like "nether"}

$roadsqueue= New-Object System.Collections.Generic.Queue[object]
$myplace=[place]::new((1,2,3))
$roadsqueue.enqueue($myplace)
$graph=new-object graph
foreach ($road in $roads) { 
    $roadsqueue.enqueue($road)

}
$roadsqueue.Count | Should BE 6
#deque 1        
$dequeue=$roadsqueue.dequeue()
$dequeue|should not be $null
$startvertex = new-object vertex $dequeue
$roadsqueue.ForEach(
{

$weight=([road]::calcroute($dequeue,$_)).weight

$endvertex =new-object vertex $_
$newedge = [edge]::new($startvertex,$endvertex,$weight)

$graph.addedge($newedge)
$weight |should not be 0
}
)
#deque 2
$dequeue=$roadsqueue.dequeue()
$dequeue|should not be $null
$startvertex = new-object vertex $dequeue

$roadsqueue.ForEach(
{

$weight=([road]::calcroute($dequeue,$_)).weight

$endvertex =new-object vertex $_
$newedge = [edge]::new($startvertex,$endvertex,$weight)

$graph.addedge($newedge)
$weight |should not be 0
}
)

         }
        }
         <# 
        it 'test the error with graph function'{

            $placecoordinate =[placecoordinate](1,2,3)
            $graph = graph $placecoordinate 
            $roads = import-Clixml c:\ex-sys\xml\roads.xml
            
        }

        it 'test the graph function 3 '{
            $placecoordinate =[placecoordinate](1,2,3)
            $graph = graph $placecoordinate
            


            $GRAPH.vertices[4].edges.First.next.next.Value.endVertex|should not be $null
            $GRAPH.vertices[3].edges.First.next.next.Value.endVertex|should not be $null
            $GRAPH.vertices[2].edges.First.next.next.Value.endVertex|should not be $null
            $GRAPH.vertices[1].edges.First.next.next.Value.endVertex|should not be $null
            $GRAPH.vertices[0].edges.First.next.next.Value.endVertex|should not be $null
        }



    
        it 'test graph function 1' {
            $placecoordinate=[placecoordinate](1,2,3)
            $queue = [System.Collections.Generic.Queue[object]]::new()
            $queue.enqueue($placecoordinate)
            $roads=import-Clixml "C:\ex-sys\xml\roads.xml"
            $graph = New-Object Graph
            $vertexA=New-Object vertex $roads[1]
            $vertexB=New-Object vertex $roads[2]
            $vertexC=New-Object vertex $roads[3]
            $vertexD=New-Object vertex $roads[4]
            $vertexE = New-Object Vertex $roads[5]
            $edgeAB = New-Object edge $vertexA,$vertexB
            $edgeAD = New-Object edge $vertexA,$vertexD
            $edgeAC=New-Object edge $vertexA,$vertexC
            $edgeAE=New-Object edge $vertexA,$vertexE
            $edgeBC=New-Object edge $vertexB,$vertexc 
            $edgeBD=New-Object edge $vertexB,$vertexD
            $edgeBE=New-Object edge $vertexB,$vertexE
            $edgecd =New-Object edge $vertexC,$vertexD
            $edgeCE=New-Object EDGE $vertexC,$vertexE
            $edgeDE=New-Object EDGE $vertexD,$vertexE
            $graph.addEdge($edgeAB)       
            $graph.addEdge($edgeAD)
            $graph.addEdge($edgeAC)
            $graph.addEdge($edgeAE)
            $graph.addedge($edgeBC)
            $graph.addedge($edgeBD)
            $graph.addedge($edgeBE)
            $graph.addedge($edgeCD)
            $graph.addedge($edgeCE)
            $graph.addedge($edgeDE)
            $graph.vertices
            $graph.vertices[0].edges.First.Value.startVertex.edges|should not be $null
            $graph.vertices[0].edges.First.next.Value.startVertex.edges|should not be $null
            
            $graph.vertices[1].edges.First.Value.startVertex.edges|should not be $nu

            $graph.vertices[2].edges.First.Value.startVertex.edges|should not be $null
            $graph.vertices[3].edges.First.Value.startVertex.edges|should not be $null
            $graph.vertices[1].edges.First.Next.Value.endVertex.edges|should not be $null
            $graph.vertices[1].edges.First.Next.Value.startVertex.edges|should not be $null
            $graph.vertices
            
        }

        it 'test graph function 2'{

            
        $roads=import-Clixml "C:\ex-sys\xml\roads.xml"
        $graph=[graph]::new()
        $placecoordinate=[placecoordinate](1,2,3)
        $roadsqueue=[System.Collections.Generic.Queue[object]]::new()
        $roadsqueue.enqueue($placecoordinate)
        foreach ($road in $roads){

            $roadsqueue.enqueue($road)

        }


do {
$inque = $roadsqueue.dequeue()
$startVertex =  New-Object vertex $inque
$roadsque =$roadsqueue.toArray()
foreach ($roadque in $roadsque){
    
    $endVertex = New-Object vertex $roadque
    $newedge = New-Object edge $startVertex,$endVertex
    $graph.addedge($newedge)

}

    
} while (
$roadsqueue.count -gt 0
)


$graph.vertices[0].edges.First.Value.startVertex.edges|should not be $null
$graph.vertices[0].edges.First.next.Value.startVertex.edges|should not be $null

$graph.vertices[1].edges.First.Value.startVertex.edges|should not be $null
$graph.vertices[2].edges.First.Value.startVertex.edges|should not be $null
$graph.vertices[3].edges.First.Value.startVertex.edges|should not be $null



        
  
        }


        it 'test findedge'{


                $placecoordinate=[placecoordinate](1,2,3)
                $graph = graph $placecoordinate
                
                $startvertex=$graph.vertices[0]
                $endvertex=$graph.vertices[1]


                $targetEdge = $graph.findedge($startVertex,$endvertex)
                $targetEdge|should not be $null
                $targetEdge.getkey()|should be "O_10"



                $startvertex=$graph.vertices[1]
                $endvertex=$graph.vertices[2]

           
                $targetEdge = $graph.findedge($startVertex,$endvertex)
                $targetEdge|should not be $null
                $targetEdge.getkey()|should be "10_9"

        }

        it 'find the edge'{
  
            $placecoordinate=[placecoordinate](1,2,3)
            $graph=graph $placecoordinate
            $startvertex=$graph.vertices[2]
            $endvertex=$graph.vertices[3]
            $vertex = $graph.getVertexByKey($startVertex.getkey())
            $vertex|should not be $null
            
            
            
            

        }
    
        
        it 'test  the getvertex by key'{
            $placecoordinate=[placecoordinate](1,2,3)
            $graph=graph $placecoordinate
            $edge= $graph.edges[1]
            $startVertex = $graph.getVertexByKey($edge.startVertex.getKey())
            $endVertex = $graph.getVertexByKey($edge.endVertex.getKey())
            $endvertex|should not be $null
            $startvertex|should not be $null
       
        
        }
        it 'test the generate graph'{

            $graph=[graph]::new()
         
    $roads=import-Clixml "C:\ex-sys\xml\roads.xml"


    
    $queue = [System.Collections.Generic.Queue[object]]::new()
    $queue.enqueue($placecoordinate)
    foreach($road in $roads) {
        $queue.enqueue($road)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    }
    $currentque=$queue.dequeue()
    $que = $queue.toArray()
    $que.count|should not be $null

    $startVertex=[vertex]::new($currentque)
    $endVertex=[vertex]::new($que[0])
    
    $graph.addEdge([edge]::new($startVertex,$endVertex)) 
    $endVertex=[vertex]::new($que[1])
    $endVertex|should not be $null
    $graph.getVertexByKey($endVertex.getkey())|should be $null
    
    $graph.addEdge([edge]::new($startVertex,$endVertex))
    $endVertex=[vertex]::new($que[2])
    $endVertex|should not be $null  
    $graph.getVertexByKey($endVertex.getkey())|should be $null
        }
        

        it 'test the add edges for getneighbors' {
            $placecoordinate=[placecoordinate](1,2,3)
            $graph = graph $placecoordinate
            $graph.vertices[1].edges.endvertex[0].edges.First.Value.getKey()#1
            $graph.vertices[1].edges.endvertex[0].edges.First.next.Value.getKey()#1
            $graph.vertices[1].edges.endvertex[0].edges.First.next.next.Value.getKey()#2
            $graph.vertices[1].edges.endvertex[0].edges.First.next.next.next.Value.getKey()#3
            $graph.vertices[1].edges.endvertex[0].edges.First.next.next.next.next.Value.getKey()#4
            $graph.vertices[0].edges.endvertex[0].edges.First.Value.getKey()#1
            $graph.vertices[0].edges.endvertex[0].edges.First.next.Value.getKey()#1
            $graph.vertices[0].edges.endvertex[0].edges.First.next.next.Value.getKey()#2
            $graph.vertices[0].edges.endvertex[0].edges.First.next.next.next.Value.getKey()#3
            $graph.vertices[0].edges.endvertex[0].edges.First.next.next.next.next.Value.getKey()#4
        }
    

        it 'add edges to graph'{
            $roads=import-Clixml "C:\ex-sys\xml\roads.xml"


    
            $queue = [System.Collections.Generic.Queue[object]]::new()
            
    foreach($road in $roads) {
        $queue.enqueue($road)
    }
    $que=$queue.toArray()    
        $graph=[graph]::new()
        $startVertex=[vertex]::new($que[0])
        $endVertex=[vertex]::new($que[1])
        $graph.addEdge([edge]::new($startVertex,$endVertex))
        $startVertex=[vertex]::new($que[2])
        $endVertex=[vertex]::new($que[3])
        $graph.addEdge([edge]::new($startVertex,$endVertex))
        $graph.edges.Count|Should be 2
    


            }


} #>
        context 'bellman fold'{
<# 
    it 'get distanceskey' {
        $placecoordinate=[placecoordinate](1,2,3)
        $graph = graph $placecoordinate
        $startVertex=$graph.vertices[0]
        
        $distances = @{}
        $previousVertices = @{}
    
        # Init all distances with infinity assuming that currently we can't reach
        # any of the vertices except start one.
        $distances[$startVertex.getKey()] = 0
        foreach ($vertex in $graph.getAllVertices()) {
            $previousVertices[$vertex.getKey()] = $null
            if ($vertex.getKey() -ne $startVertex.getKey()) {
                $distances[$vertex.getKey()] = [double]::PositiveInfinity
            }
        }
    

        $distancesKeys = $distances.Keys
    
        $distancesKeys|should not be $null
    }

    it 'test litergation part 1' {

           ##gey distance key
    $placecoordinate=[placecoordinate](1,2,3)
    $graph = graph $placecoordinate
    $distances = @{}
    $previousVertices = @{}
    $startVertex = $graph.vertices[0]
    # Init all distances with infinity assuming that currently we can't reach
    # any of the vertices except start one.
    $distances[$startVertex.getKey()] = 0
    foreach ($vertex in $graph.getAllVertices()) {
        $previousVertices[$vertex.getKey()] = $null
        if ($vertex.getKey() -ne $startVertex.getKey()) {
            $distances[$vertex.getKey()] = [double]::PositiveInfinity
        }
    }
    for ($iteration = 0; $iteration -lt ($graph.getAllVertices().count - 1); $iteration += 1) {

        $distancesKeys = $distances.Keys

        foreach($vertexkey in $distancesKeys){

             $vertex = $graph.getVertexByKey($vertexKey)
             $vertex |should not be $null                                   
        }
        
    
    }
    

    }
    it 'test the literation part 3' {
        $placecoordinate=[placecoordinate](1,2,3)
        $graph = graph $placecoordinate
        $distances = @{}
        $previousVertices = @{}
        $startVertex = $graph.vertices[0]
        # Init all distances with infinity assuming that currently we can't reach
        # any of the vertices except start one.
        $distances[$startVertex.getKey()] = 0
        $graph.getAllVertices() | should not be $null
        foreach ($vertex in $graph.getAllVertices()) {
            $previousVertices[$vertex.getKey()] = $null
            if ($vertex.getKey() -ne $startVertex.getKey()) {
                $distances[$vertex.getKey()] = [double]::PositiveInfinity
            }
        }
        $graph.getAllVertices.count.gettype() | should be "int"
        $graph.getAllVertices.count.gettype() | should not be $null
        
        $vertex = $graph.vertices[1]
        $vertex |should not be $null

        $graph.getneighbors($vertex)|should not be $null

        $neighbor = $graph.getNeighbors($graph.vertices[1])[1]
        $distanceToVertex = $distances[$vertex.getKey()]
        $distanceToNeighbor =$distanceToVertex+  $edge.weight.distance

        if ($distanceToNeighbor -lt $distances[$neighbor.getKey()]) {
            $distances[$neighbor.getKey()] = $distanceToNeighbor
              $previousVertices[$neighbor.getKey()] = $vertex
              $distanceToNeighbor.gettype()|should be "double"
          
  
          }
          $distances, $previousVertices
    }

    it 'test the literation part 2 '{

         ##get distance key
         $placecoordinate=[placecoordinate](1,2,3)
         $graph = graph $placecoordinate
         $distances = @{}
         $previousVertices = @{}
         $startVertex = $graph.vertices[0]
         # Init all distances with infinity assuming that currently we can't reach
         # any of the vertices except start one.
         $distances[$startVertex.getKey()] = 0
         $graph.getAllVertices() | should not be $null
         foreach ($vertex in $graph.getAllVertices()) {
             $previousVertices[$vertex.getKey()] = $null
             if ($vertex.getKey() -ne $startVertex.getKey()) {
                 $distances[$vertex.getKey()] = [double]::PositiveInfinity
             }
         }
         $graph.getAllVertices.count.gettype() | should be "int"
         $graph.getAllVertices.count.gettype() | should not be $null
         for ($iteration = 0; $iteration -lt ($graph.getAllVertices().count - 1); $iteration += 1) {
     
          $distancesKeys = $distances.Keys

          
             foreach($vertexkey in  $distancesKeys){
     
              $vertex = $graph.getVertexByKey($vertexKey)
              $vertex |should not be $null

              $graph.getneighbors($vertex)|should not be $null

              $neighbor = $graph.getNeighbors($graph.vertices[1])[1]
              
              $edge = $graph.findEdge($vertex, $neighbor)
              $edge|should not be $null
               # Find out if the distance to the neighbor is shorter in this iteration
              # then in previous one.
              $distanceToVertex = $distances[$vertex.getKey()]
              $distanceToNeighbor =$distanceToVertex+  $edge.weight.distance
              
       
             }
             
         
         }
        }
#>
it ' test the bellmanford' {
    $mycoordinate =[place]::new((1,2,3))
    $placecoordinate = [place]::new((500,0,-1000),"p")
    $graph=graph $mycoordinate $placecoordinate "nether"
    $PATHS=bellman-ford $GRAPH
    
    $paths | should not be $null 
    $DISTANCES = $PATHS[0]
    $distances | should not be $null
    $PREviousvertices=$PATHS[1]
    $VERTICES=$previousvertices.Keys.ForEach({$_})
    #target vertices
    $DISTANCES.Keys
    #previous Vertices
    $PREviousvertices.Values.value

    $DISTANCES[$vertices[0]]|should not be $null
    $DISTANCES[$vertices[1]]|should not be $null
    $DISTANCES[$vertices[2]]|should not be $null
    $DISTANCES[$vertices[3]]|should not be $null
    $DISTANCES[$vertices[4]]|should not be $null
    $DISTANCES[$vertices[5]]|should not be $null
    $DISTANCES[$vertices[6]]|should not be $null
}


it 'test findedge'{
    $mycoordinate =[place]::new((1,2,3))
    $placecoordinate = [place]::new((500,0,-1000),"p")
    $graph=graph $mycoordinate $placecoordinate "nether"
    $vertex1= $graph.getVertexByKey("P")
    $vertex2=$GRAPH.getVertexByKey("O")
    $edge = $graph.findEdge($vertex1, $vertex2)
    $edge|Should not be $null   


}


<# 

it 'test the literation' {

           ##get distance key
           $placecoordinate=[placecoordinate](1,2,3)
           $graph = graph $placecoordinate
           $distances = @{}
           $previousVertices = @{}
           $startVertex = $graph.vertices[0]
           # Init all distances with infinity assuming that currently we can't reach
           # any of the vertices except start one.
           $distances[$startVertex.getKey()] = 0
           $graph.getAllVertices() | should not be $null
           foreach ($vertex in $graph.getAllVertices()) {
               $previousVertices[$vertex.getKey()] = $null
               if ($vertex.getKey() -ne $startVertex.getKey()) {
                   $distances[$vertex.getKey()] = [double]::PositiveInfinity
               }
           }
           $graph.getAllVertices.count.gettype() | should be "int"
           $graph.getAllVertices.count.gettype() | should not be $null
           for ($iteration = 0; $iteration -lt ($graph.getAllVertices().count - 1); $iteration += 1) {
       
            $distancesKeys = $distances.Keys

            try {
                foreach($vertexkey in  $distancesKeys){
        
                    $vertex = $graph.getVertexByKey($vertexKey)
             
    
                    #go through all edges
                    foreach ($neighbor in $graph.getneighbors($vertex) ) {
                        $edge = $graph.findEdge($vertex, $neighbor)
                    # Find out if the distance to the neighbor is shorter in this iteration
                    # then in previous one.
                      
                        $distanceToVertex = $distances[$vertex.getKey()]
                        $distanceToNeighbor =$distanceToVertex+$edge.weight.distance
                        $Neighbordistance = $distances[$neighbor.getkey()]  
                        if ($distanceToNeighbor -lt $Neighbordistance  ) {
                           $distances[$neighbor.getkey()]   = $distanceToNeighbor
                              $previousVertices[$neighbor.getKey()] = $vertex
                              
                          
                  
                          }
    
                        }
                    }
                
             }
             catch {
                
             }  
               }
               
           
           }
            it 'test the bellmanford distance' {
                $PLACEcoordinate=[placecoordinate](1,2,3)   
                $graph =graph $PLACEcoordinate
                $paths=bellman-ford $graph
                $paths | should not be $null    
                $paths[0].values
                $paths[0].values|should not be $null
                $distances= $paths[0].Values.ForEach({$_})
                $distances|should not be $null
                 
            }
           it 'run the bellmanfold function' {
            $placecoordinate=[placecoordinate](1,2,3)
    
            $graph = graph $placecoordinate
            $startVertex =$graph.vertices[0]
            $startVertex | should not be $null
            
            $graph=graph $PLACEcoordinate
            $paths=bellman-ford  $GRAPH
            $paths|should not be $null
           }
  it 'test get vertex by road '{
    $mycoordinate= [placecoordinate](1,2,3)
    $graph = graph $mycoordinate
    $targetroad = (import-Clixml c:\ex-sys\xml\roads.xml)[2]
    $paths=bellman-ford $graph
    $paths|should not be $null
    $graph.getVertexByKey($targetroad)|should not be $null


  }
it 'test the for synax'{

    for ($i = 0; $i -lt 5; $i+=$distance) {
        $distance=1
    }
}
it 'test the get distance from keys' {
    $roads = import-Clixml c:\ex-sys\xml\roads.xml
    $placecoordinate = [placecoordinate](1,2,3)
    $graph=graph $placecoordinate
    $paths=bellman-ford $graph
    
    $targetroad=$roads|Where-Object {$_.id -eq 4}
    $distances = $paths[0]
    $distance= $distances[$targetroad.id]|should not be $null

}
#>    
}

}

