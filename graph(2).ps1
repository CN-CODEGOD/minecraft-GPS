function graph (
[place]$myplace,
[place]$destination,
[dimension]$dimension


){
    $roads=import-Clixml $PSScriptRoot\xml\roads.xml|Where-Object {$_.dimension -like $dimension}
    
    

$roadsqueue = New-Object System.Collections.Generic.Queue[object]

  $roadsqueue.enqueue($myplace)
foreach ($road in $roads) { 
    $roadsqueue.enqueue($road)

}

$roadsqueue.enqueue($destination)

if ($roadsqueue.dequeue){
$dequeue = $roadsqueue.dequeue
$startvertex= new-object vertex $dequeue
$roadsqueue|% {
    $endvertex=new-vertex $_
    $newedge = [edge]::new($startvertex,$endvertex)
    $graph.addedge($newedge)
    
    

}
}
    

   
 $graph

}