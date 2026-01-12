. "$PSScriptRoot/graph.class.ps1"
. "$PSScriptRoot/gps.class.ps1"



$example_place1=[place]::new(([PSCustomObject]@{
   placecoordinate=(1,2,3)
   
}))
$example_place2=[place]::new(([PSCustomObject]@{
    placecoordinate=(3,4,5)
    
 }))
