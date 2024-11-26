using module "C:\Program Files\PowerShell\7\Modules\minecraft-GPS\minecraft-GPS.PSM1"



$example_place1=[place]::new(([PSCustomObject]@{
   placecoordinate=(1,2,3)
   
}))
$example_place2=[place]::new(([PSCustomObject]@{
    placecoordinate=(3,4,5)
    
 }))
 
[]