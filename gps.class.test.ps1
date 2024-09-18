describe 'gps class' {
    beforeAll{
. "$Psscriptroot\graph.class.ps1"        
. "$PSScriptRoot\gps.class.ps1"
 
$road1= [road]([pscustomobject]@{
    

    
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

$road2= [road]([pscustomobject]@{
   

    
roadcoordinate=[pscustomobject]@{
roadcoordinate1=[pscustomobject]@{
x=20
y=20
z=20}
roadcoordinate2=[pscustomobject]@{
x=2
y=1
z=2}}
id=0
})

$placecoordinate1=[System.Numerics.Vector3]::new(1,2,50)
    }
    context 'calcroute'{

        it 'road-road'{
            $route = [road]::calcroute($road1,$road2)
$route|should not be $null
$route.startVertex|should not be $null
$route.endvertex|should not be $null
        }
        it 'place-road'{
$route = [road]::calcroute($placecoordinate1,$road2)
$route|should not be $null
$route.startVertex|should not be $null
$route.endvertex|should not be $null
        }
        it 'road-place'{
$route = [road]::calcroute($road1,$placecoordinate1)
$route|should not be $null
$route.startVertex|should not be $null
$route.endvertex|should not be $null
        }
    }
    context 'import-xml'{
        it 'road'{
         $road1.save()
         import-xml $road1.path|should not be $null

    }

    it 'survival_place ' {

        $survival_place = [survival_place]([pscustomobject]@{placecoordinate = @{

            x=1
            y=1
            z=1}})
            $survival_place.save()
            import-xml $survival_place.path |Should not be $null

    
    
        }
        it 'teleportation_place'{

            $teleportation_place =  [teleportation_place]([pscustomobject]@{placecoordinate = @{
                x=1 
                y=1
                
            }})
            save-object $teleportation_place
            import-xml $teleportation_place.path|Should not be $nul

        }
        it 'wynncraft_place'{
            $wynncraft_place =  [wynncraft_place]([pscustomobject ]@{
                placecoordinate = 
                @{
                    x=1
                    y=1
                    z=1
                
                }


            })
            save-object -object $wynncraft_place 
            import-xml $wynncraft_place.path |Should not be $null
        }
}
}