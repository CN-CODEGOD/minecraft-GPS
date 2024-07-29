. $PSScriptRoot\gps.class.ps1

describe 'test gps class'{
context 'INIT'{
 it 'wynncraft_place'{

$wynncraft_place  =[wynncraft_place]((1,2,3),"blacksmith")
$wynncraft_place.placecoordinate|should not be $null    
$wynncraft_place.type |should be "blacksmith"

 }

 it 'survival_place'{
$survival_place=[survival_place]((1,2,3),"the_end","cave")
$survival_place.placecoordinate|should not be $null
$survival_place.dimension|should be "the_end"
$survival_place.type|should be "cave"

 }
it 'teleportation_place'{
$teleportation_place = [teleportation_place]((1,2,3),"test")
$teleportation_place.placecoordinate|should not be $null
$teleportation_place.name |should be "test"

}
it 'road'{

    $road =[road]((1,2,3,4,5,6),"the_end")
    $road.roadcoordinate|should not be $null
    $road.dimension|should not be $null
    $road = [road]"the_end"
    $road.dimension|should be "the_end"
    $road= [road]2
    $road.id|should be 2
}


}
context 'calcroute'{

<# 
    it 'test calcroute for placecoordinate placecoordinate'{
        $placecoordinate1
        $placecoordinate2
        $weight = [road]::calcroute($placecoordinate1,$placecoordinate2)
        $weight.projectedpoint |should be $placecoordinate2
        


    }
    
    it 'test  calcroute method '{
        $roads= import-Clixml c:\ex-sys\xml\roads.xml
        $road1=$roads|Where-Object {$_.id -eq 4}
        $road2=$roads|Where-Object {$_.id -eq 5}
  
        $startroadcoordinate=$road1.roadcoordinate

        $endroadcoordinate=$road2.roadcoordinate
         
        $s0=[System.Numerics.Vector3]::new($startroadcoordinate.x,$startroadcoordinate.y,$startroadcoordinate.z)
        $s1=[System.Numerics.Vector3]::new($startroadcoordinate.x1,$startroadcoordinate.y1,$startroadcoordinate.z1)
        $t0=[System.Numerics.Vector3]::new($endroadcoordinate.x,$endroadcoordinate.y,$endroadcoordinate.z)
        $t1=[System.Numerics.Vector3]::new($endroadcoordinate.x1,$endroadcoordinate.y1,$endroadcoordinate.z1)
$s0.x|should not be $null
$s1.x|should not be $null
$t0.x|should not be $null
$t1.x|should not be $null
#定义向量
$u = $s1-$s0
$v=$t1-$t0
$w0= $s0-$t0

$u.x|should not be $null
$v.x|should not be $null
$w0.x|Should not be $null
$a = [System.Numerics.Vector3]::dot($u,$u)
$b= [System.Numerics.Vector3]::dot($u,$v)
$c=[System.Numerics.Vector3]::dot($v,$v)
$d=[System.Numerics.Vector3]::dot($u,$w0)
$e=[System.Numerics.Vector3]::dot($v,$w0)
$a.gettype()|should be "float"
$b.gettype()|should be "float"
$c.gettype()|should be "float"
$d.gettype()|should be "float"
$e.gettype()|should be "float"
try{

    $sc= ($b*$e-$c*$d)/($a*$c-$b*$b)

    $tc=($a*$e-$b*$d)/($a*$e-$b*$b)
    
}


catch {
 $sc = 0
 $tc = $e/$c
}
$sc.gettype()|should be "double"
$tc.gettype()|should be "double"
$startroadprojectedpoint= $s0+$sc*$u
$endroadprojectedpoint =$t0+$sc*$v

    }
    it 'test dot '{
        $a = [System.Numerics.Vector3]::new(1,2,3)
        $b = [System.Numerics.Vector3]::new(3,2,1)
        [System.Numerics.Vector3]::dot($a,$b)|should be 10
    }
    it '求法向量' {

     $a=@{
        x=1
        y=2
        z=3
     }
       $b=@{
        x=3
        y=2
        z=1
       }
    $p=@{
        x=3
        y=6
        z=9
    }
    $v=[System.Numerics.Vector3]::new($p.x-$a.x,$p.y-$a.y,$p.z-$a.z)
    $u=  [System.Numerics.Vector3]::new($p.x-$b.x,$p.y-$b.y,$p.z-$b.z)

        $n  =[System.Numerics.Vector3]::new($v.y*$u.z-$v.z*$u.y,$v.z*$u.x-$v.x*$u.z,$v.x*$u.y-$v.y*$u.x)
        
        [System.Numerics.Vector3]::dot($n,$v)|should be 0

    }
    it 'test calcplanecoordinate' {
        $roads=import-Clixml "C:\ex-sys\xml\roads.xml"
        $road=$roads[1]
        class placecoordinate {
            [int]$x
            [int]$y
            [int]$z
            [string]$id
            static [void]validate ([array]$coordinate){
                if ($coordinate.count -ne 3) {
                    throw "the coordinate is valid,please input a (x,y,z),coordinate"
                }
        
                
            }
            placecoordinate([array]$placecoordinate){
                [placecoordinate]::validate($placecoordinate)
                $this.x=$placecoordinate[0]
                $this.y=$placecoordinate[1]
                $this.z=$placecoordinate[2]
                $this.id ='O'
            }
        }

        $p = [placecoordinate](1,2,3)
        $targetcoordinate= [System.Numerics.Vector2]::NEW(1,3)
 $C=[main]::calcplane($road,$p,$targetcoordinate)
 
$C.Y|should be 2
 
 

    }
    it 'test placecoordinate-road calcroute method'{
        $roads = import-Clixml c:\ex-sys\xml\roads.xml
        $road=$roads[1]
        $placecoordinate=[placecoordinate](4,5,6)
        
        $result = [road]::calcroute($placecoordinate,$road)
        $result|should not be $null
        $result.projectedpoints.startVertex.x|should not be $null
        $result.projectedpoints.startVertex.y|should not be $null
        $result.projectedpoints.startVertex.z|should not be $null
        $result.projectedpoints.endVertex.x|should not be $null
        $result.projectedpoints.endVertex.y|should not be $null
        $result.projectedpoints.endVertex.z|should not be $null

        
    }
   
    it 'test calcroute method place-place'{
        $mycoordinate =[placecoordinate](1,2,3)
        $destination =[placecoordinate](100,100,100)
        
        
        $result = [main]::calc($mycoordinate,$destination)
        $result.weight.gettype() | should be int
    }#>
    it 'test road-road calcroute method' {

        ## test dot1 or dot2 -gt 0 
        $roadcoordinate1 = [roadcoordinate](100,1,0,100,2.81,5)
        $roadcoordinate = [roadcoordinate](-6,1,0,-0,2.81,5)
        $road1 = [road]($roadcoordinate,"the_end")
        $road2 = [road]($roadcoordinate1,"the_end")
        
        
                $result = [road]::calcroute($road1,$road2)
                $result.projectedpoints.startVertex.x|should not be $null
                $result.projectedpoints.startVertex.y|should not be $null
                $result.projectedpoints.startVertex.z|should not be $null
                $result.projectedpoints.endVertex.x|should not be $null
                $result.projectedpoints.endVertex.y|should not be $null
                $result.projectedpoints.endVertex.z|should not be $null
        
        
        
                ## test dot1 and dot2 -lt 0
                $roadcoordinate1= [ROADCoordinate](1.88,70,3.54,0,10,5.04)
                $roadcoordinate2= [ROADCoordinate](0.43,100,5,2.8,0,4.12)
                $road1= [road]($roadcoordinate1,"the_end")
                $road2= [road]($roadcoordinate2,"the_end")
                $result = [road]::calcroute($road1,$road2)
                
                $result|Should not be $null
                
                
        
            }
            <#    it "test calcroute method DoInit"{

        $roadcoordinate1 = [roadcoordinate](100,1,0,100,2.81,5)
$roadcoordinate = [roadcoordinate](-6,1,0,-0,2.81,5)
$road1 = [road]($roadcoordinate,"the_end")
$road2 = [road]($roadcoordinate1,"the_end")


        $result = [road]::calcroute($road1,$road2)
        $result.mark | should be "road-road"

        $place1 =[place]::new((1,2,3))
        $place2 = [place]::new((3,4,5))
        $result =[road]::calcroute($place1,$place2)
        $result.mark | should be "place-place"
        $result = [road]::calcroute($road1,$place1)
        $result.mark|should be "road-place"
        $result=[road]::calcroute($place1,$road1)
        $result.mark|should be "place-road  "

    } #>

}


it 'test road-road'{
$roads = import-Clixml $home\bfs\xml\roads.xml
$route  = [road]::calcroute($roads[1],$roads[2])
$route|should not be $null
$route.weight|should not be $null
$route.startVertex|should not be $null
$route.endvertex|should not be $null
$roadcoordinate1=[ROADCoordinate]::NEW(1,0,5,1,0,3)
$roadcoordinate1=[ROADCoordinate]::NEW(1,0,1,5,0,1)
$road1=[ROAD]($roadcoordinate1,"nether")
$road2=[road]($roadcoordinate2,"nether")
$route  = [road]::calcroute($road1,$road2)
}
it 'test place-place'{

    $place1=[place]::new((0,0,0))
    $place2=[place]::new((100,0,0))
    $result = [road]::calcroute($place1,$place2)
    $result.weight|should be 100
}
it 'get projected points' {
    $roadcoordinate1=[ROADCoordinate](1,0,5,1,0,3)
    $roadcoordinate1=[ROADCoordinate](1,0,1,5,0,1)
    $road1=[ROAD]($roadcoordinate1,"nether")
    $road2=[road]($roadcoordinate2,"nether")
    $route  = [road]::calcroute($road1,$road2)
}
it 'calcroute ' {
    $roads=import-Clixml $PSScriptRoot\xml\roads.xml
    $road1=$roads[1]
    $road2=$roads[2]
    $a= [place]::new((4,5,6))
    $b= [place]::new((10,20,30))
    $c= [place]::new((30,40,30))
    $d= [place]::new((50,60,70))
    $MinDis = ([road]::calcroute($a,$road2)),([road]::calcroute($b,$road2)),([road]::calcroute($c,$road1)),([road]::calcroute($d,$road1))|Sort-Object -Property weight |select-object -first 1
}
context "classes"{
    beforeALL {
$placecoordinate= [placecoordinate](1,2,3)
$roadcoordinate1=[roadcoordinate](1,2,3,4,5,6)
$roadcoordinate2=[roadcoordinate](4,5,6,7,8,9)
    }

    it 'placecoordinate'{
[placecoordinate](1,2,3)

    }
    it 'roadcoordinate'{
[roadcoordinate](1,2,3,4,5,6)

    }

    it 'road'{

    }
    it 'wynncraft_place'{

    }
    it 'survival_place'{

    }
    it 'teleportation_place'{


    }
}
}
