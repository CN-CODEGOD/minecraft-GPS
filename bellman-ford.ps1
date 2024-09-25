

function bellman-ford {
    param (
    
      $GRAPH
 
        
    )
  ##get distances,previousvertex
   
        
  $distances = @{}
  $previousVertices =@{}
  $startVertex = $graph.getVertexByKey("O")
  
  # Init all distances with infinity assuming that currently we can't reach
  # any of the vertices except start one.
  $distances[$startVertex.getKey()] = 0

  foreach ($vertex in $graph.getAllVertices()) {
      $previousVertices[$vertex.getKEY()] = $null
      if ($vertex.getKey() -ne $startVertex.getKey()) {
          $distances[$vertex.getKey()] = @{weight =[double]::PositiveInfinity} 
      }
  }


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
            
              $distanceToVertex = ($distances[$vertex.getKey()]).weight
              $distanceToNeighbor =$distanceToVertex + $edge.weight.weight
              $Neighbordistance = ($distances[$neighbor.getkey()]  ).weight
              if ($distanceToNeighbor -lt $Neighbordistance  ) {
                 $distances[$neighbor.getkey()]   = $edge.weight
                    $previousVertices[$neighbor.getKEY()] = $vertex
                    
                
        
                }

              }
          }
      
   }
   catch {
      
   }
     
 
      }
      function Get-Path {
        param (
            $previousVertices,
            $endvertex
        )
        
        $path = @()
        $currentVertex = $endvertex
        
        while ($currentVertex -ne $null) {
            $path = @($currentVertex) + $path
            $currentVertex = $previousVertices[$currentVertex]
        }
    
        return $path
    }
    $endvertex = $GRAPH.getVertexByKey("p")
    
    $path = Get-Path -previousVertices $previousVertices -endvertex $endvertex
    return $distances, $previousVertices, $path
    
      
      


    
}

