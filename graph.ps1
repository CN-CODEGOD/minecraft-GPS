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
$destination.id="P"
$graph = New-Object Graph
$roadsqueue= New-Object System.Collections.Generic.Queue[object]
$roadsqueue.enqueue($myplace)
foreach ($road in $roads) { 
    $roadsqueue.enqueue($road)

}

$roadsqueue.enqueue($destination)

    
do {
    $dequeue=$roadsqueue.dequeue()
    $startvertex = new-object vertex $dequeue
  $roadsqueue.ForEach(
   {
   
   $weight=[road]::calcroute($dequeue,$_)
   
   $endvertex =new-object vertex $_
   $newedge = [edge]::new($startvertex,$endvertex,$weight)

   $graph.addedge($newedge)

   }

  )
   
    
} until (
$roadsqueue.Count -eq 0
)
  
    
  
    $graph
}