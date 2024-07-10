. $PSScriptRoot\graph.class.ps1

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
          $distances[$vertex.getKey()] = [double]::PositiveInfinity
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
            
              $distanceToVertex = $distances[$vertex.getKey()]
              $distanceToNeighbor =$distanceToVertex + $edge.weight.distance
              $Neighbordistance = $distances[$neighbor.getkey()]  
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
      $distances,$previousVertices
      
      


    
}

      