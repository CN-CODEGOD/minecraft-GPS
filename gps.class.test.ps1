describe 'gps class' {
    beforeAll{
. "C:\Users\34683\BFS\graph.class.ps1"        
. "C:\Users\34683\BFS\gps.class.ps1"
 
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
    context 'save'{
        it 'road'{
            [xml]$object = $road1.save()
            save-object $object
            import-xml $road1.path

    }

}
}