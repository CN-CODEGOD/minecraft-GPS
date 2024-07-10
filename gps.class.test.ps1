. $PSScriptRoot\gps.class.ps1
. $PSScriptRoot\graph.class.ps1
. $PSScriptRoot\graph.ps1
. $PSScriptRoot\bellman-ford.ps1

describe 'test gps class'{
context 'calcroute'{

    it 'test calc route projected point'{
        $roads= import-Clixml c:\ex-sys\xml\roads.xml
        $road1=$roads|Where-Object {$_.id -eq 4}
        $road2=$roads|Where-Object {$_.id -eq 5}
        $weight = [road]::calcroute($road1,$road2)
        $weight.startpoint.x|should not be $null
        $weight.startpoint.y|should not be $null
        $weight.startpoint.z|should not be $null
        $weight.endpoint.x|should not be $null
        $weight.endpoint.y|should not be $null
        $weight.endpoint.z|should not be $null
         
        

    }
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
    }
    
}


}