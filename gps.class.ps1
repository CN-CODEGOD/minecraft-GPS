. $PSScriptRoot\graph.class.ps1
# basic CLASS

## [placecoordinate]

class placecoordinate {
    [double]$x
    [double]$y
    [double]$z
  
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
        
    }
}
## element class for line coordinate
class roadcoordinate {
[double]$x
[double]$y
[double]$z
[double]$x1    
[double]$y1
[double]$z1

roadcoordinate([array]$roadcoordinate){
    $this.validation($roadcoordinate)

    $this.x=$roadcoordinate[0]
    $this.y=$roadcoordinate[1]
    $this.z=$roadcoordinate[2]
    $this.x1=$roadcoordinate[3]
    $this.y1=$roadcoordinate[4]
    $this.z1=$roadcoordinate[5]
}
### validation
[void]validation($property){
    if ($property.count -ne 6 ) {
        throw "the roadcoordinate is invalid,it must contain xyz,x1y1z1"
    }

}

}


# advance class
## place 
class place { 

    [placecoordinate]$placecoordinate
    [string]$id
    place([placecoordinate]$placecoordinate){
        $this.Doinit($placecoordinate,"O")
    }
    place ([placecoordinate]$placecoordinate,[string]$id)
    {
        $this.DoInit($PLACEcoordinate,$id)
    }
    [void]DoInit([placecoordinate]$placecoordinate,[string]$id){
        $this.placecoordinate=$placecoordinate
        $this.id=$id

    }
}
## road
class road {

    [roadcoordinate]$roadcoordinate
    [string]$name
    [dimension]$dimension
    [int]$id
### construct





road ($properties) {

    $this.DoInit( $properties)


}

### Method

#### DoInit
[void] DoInit($value){ 
    [int32]$attempt=0
    if ([int32]::TryParse($value,[ref]$attempt))
    {
        $this.id=$value
    }
    else
    {
        $this.dimension=$value
        $this.id=-1
    }
}
#### DoInit
[void] DoInit (


[hashtable]$properties


)
{
    foreach ($property in $properties.key) {

        $this.$property =$properties.$property
    }
}
[void] DoInit([array]$array){

    ##### construct with Name 
    if ($array.count -eq 3) {
        $this.roadcoordinate=$array[0]
        $this.dimension=$array[1]
        $this.name=$array[2]
    }

    ##### Construct without Name
    elseif ($array.count -eq 2) {
        $this.roadcoordinate=$array[0]
        $this.dimension=$array[1]
        
    }
}

#### validate
static [void]validate([road]$road){

    $roads =Import-clixml $PSScriptRoot\xml\roads.xml
$roads| foreach-object { 


if (($_.roadcoordinate.x..$_.roadcoordinate.x1).contains($road.roadcoordinate.x) -and ($_.roadcoordinate.x..$_.roadcoordinate.x1).contains($road.roadcoordinate.x1) -and ($_.roadcoordinate.y..$_.roadcoordinate.y1).contains($road.roadcoordinate.y) -and ($_.roadcoordinate.y..$_.roadcoordinate.y1).contains($road.roadcoordinate.y1) -and ($_.roadcoordinate.z..$_.roadcoordinate.z1).contains($road.roadcoordinate.z) -and ($_.roadcoordinate.z..$_.roadcoordinate.z1).contains($road.roadcoordinate.z1)) 
{
throw "路线重叠"
}   

}

    
}


####calc route
<#
## calc distance between road and road 
## calc method for calc road route between destination and road Placecoordianate ==> Road
#>

static [psobject]calcroute ( 
[place]$place
,
[psobject]$road

)
{ 
    #default distance
$distance = [double]::PositiveInfinity

$roadcoordinatewtk=$road.roadcoordinate
$placecoordinate=$place.placecoordinate
    
    $a = @{
        x=$roadcoordinatewtk.x
        
        y=$roadcoordinatewtk.y
        z=$roadcoordinatewtk.z
    }
    $b = @{x= $roadcoordinatewtk.x1
       y=$roadcoordinatewtk.y1
        z=$roadcoordinatewtk.z1
    }
    $p = $placecoordinate

$OP = [System.Numerics.Vector2]::new($p.x,$p.z)
$v = [System.Numerics.Vector2]::new($b.x-$a.x,$b.z-$a.z)
$u= [System.Numerics.Vector2]::new($p.x-$a.x,$p.z-$a.z)

$oa =[System.Numerics.Vector2]::new($a.x,$a.z)

$pp1 = [System.Numerics.Vector2]::new(-$v[1],$v[0])
$ap= [System.Numerics.Vector2]::new($p.x-$a.x,$p.z-$a.z)
$r=[System.Numerics.Vector2]::dot($v,$ap)/[System.Numerics.Vector2]::dot($v,$v)
$projectedpoint="projected point"





    

if ($r -gt 1) {
    $projectedpoint=$b
    
    $distance=[math]::sqrt([math]::pow(($projectedpoint.x-$placecoordinate.x),2)+[math]::pow(($projectedpoint.z-$placecoordinate.z),2)+[math]::pow(($projectedpoint.y-$placecoordinate.y),2))
    

}

elseif ($r -lt 0) {
    $projectedpoint =$a

    $distance=[math]::sqrt([math]::pow(($projectedpoint.x-$placecoordinate.x),2)+[math]::pow(($projectedpoint.z-$placecoordinate.z),2)+[math]::pow(($projectedpoint.y-$placecoordinate.y),2))
    
}


else {

        $projectedpoint= $oa+$v*$r
    
           ### calc plane from coordinate

        




$n=[System.Numerics.Vector3]::new($v.y*$u.z-$v.z*$u.y,$v.z*$u.x-$v.x*$u.z,$v.x*$u.y-$v.y*$u.x)

$A=$n.x

$B=$n.y

$C=$n.z

$D= -($n.x*$p.x+$n.y*$p.y+$n.z*$p.z)

if ($b -eq 0) {
    return $placecoordinate.y
}

return -($projectedpoint.X*$A+$projectedpoint.Y*$C+$D)/$B







        
        $projectedpoint=[System.Numerics.Vector3]::new($projectedpoint.x,[main]::calcplane($placecoordinate,$road,$projectedpoint),$projectedpoint.y)
        
        $distance=[math]::sqrt([math]::pow(($projectedpoint.x-$placecoordinate.x),2)+[math]::pow(($projectedpoint.z-$placecoordinate.z),2)+[math]::pow(($projectedpoint.y-$placecoordinate.y),2))
        
    
}


$startVertex=$placecoordinate
$endvertex = $projectedpoint
return [edge]::new($startvertex,$endvertex,$distance)
    

    
        }
        #### calcroute 
        <#
        ## calc method for calc road route between destination and road road ==> Placecoordinate
        #>
static [psobject]calcroute ( 
    [psobject]$road
    ,
    [place]$place
    
    )
    { 
        #default distance
    $distance = [double]::PositiveInfinity
    
    $roadcoordinatewtk=$road.roadcoordinate
    $placecoordinate=$place.placecoordinate
        
        $a = [System.Numerics.Vector3]::new($roadcoordinatewtk.x,$roadcoordinatewtk.y,$roadcoordinatewtk.z)
        $b =[System.Numerics.Vector3]::new($roadcoordinatewtk.x1,$roadcoordinatewtk.y1,$roadcoordinatewtk.z1)
        $p = $placecoordinate
    
    $OP = [System.Numerics.Vector2]::new($p.x,$p.z)
    $v = [System.Numerics.Vector2]::new($b.x-$a.x,$b.z-$a.z)
    $u= [System.Numerics.Vector2]::new($p.x-$a.x,$p.z-$a.z)
    
    $oa =[System.Numerics.Vector2]::new($a.x,$a.z)
    
    $pp1 = [System.Numerics.Vector2]::new(-$v[1],$v[0])
    $ap= [System.Numerics.Vector2]::new($p.x-$a.x,$p.z-$a.z)
    $r=[System.Numerics.Vector2]::dot($v,$ap)/[System.Numerics.Vector2]::dot($v,$v)
    $projectedpoint="projected point"
    
    
    
    
    
        
    
    if ($r -gt 1) {
        $projectedpoint=$b
        
        $distance=[math]::sqrt([math]::pow(($projectedpoint.x-$placecoordinate.x),2)+[math]::pow(($projectedpoint.z-$placecoordinate.z),2)+[math]::pow(($projectedpoint.y-$placecoordinate.y),2))
        
    
    }
    
    elseif ($r -lt 0) {
        $projectedpoint =$a
    
        $distance=[math]::sqrt([math]::pow(($projectedpoint.x-$placecoordinate.x),2)+[math]::pow(($projectedpoint.z-$placecoordinate.z),2)+[math]::pow(($projectedpoint.y-$placecoordinate.y),2))
    }
    
 else {

        $projectedpoint= $oa+$v*$r
    
           ### calc plane from coordinate

        




$n=[System.Numerics.Vector3]::new($v.y*$u.z-$v.z*$u.y,$v.z*$u.x-$v.x*$u.z,$v.x*$u.y-$v.y*$u.x)

$A=$n.x

$B=$n.y

$C=$n.z

$D= -($n.x*$p.x+$n.y*$p.y+$n.z*$p.z)

if ($b -eq 0) {
    return $placecoordinate.y
}

return -($projectedpoint.X*$A+$projectedpoint.Y*$C+$D)/$B







        
        $projectedpoint=[System.Numerics.Vector3]::new($projectedpoint.x,[main]::calcplane($placecoordinate,$road,$projectedpoint),$projectedpoint.y)
        
        $distance=[math]::sqrt([math]::pow(($projectedpoint.x-$placecoordinate.x),2)+[math]::pow(($projectedpoint.z-$placecoordinate.z),2)+[math]::pow(($projectedpoint.y-$placecoordinate.y),2))
        
    
}
    
    
    $startvertex = $projectedpoint
    $endvertex =     $placecoordinate
     
    
      
    return [edge]::new($startVertex,$endvertex,$distance)
     
         
    
        
            }
    
### calcroute
        static[object] calcroute([psobject]$road1,[psobject]$road2) {

            ###### default projectedpoints
            $projectedpoints=[edge]::new($null,$null)
            
           $roadcoordinate1= $road1.roadcoordinate
           $roadcoordinate2= $road2.roadcoordinate
           $a= [System.Numerics.Vector3]::new($roadcoordinate1.X,$roadcoordinate1.Y,$roadcoordinate1.Z)
           $b= [System.Numerics.Vector3]::new($roadcoordinate1.X1,$roadcoordinate1.Y1,$roadcoordinate1.Z1)
           $c= [System.Numerics.Vector3]::new($roadcoordinate2.X,$roadcoordinate2.Y,$roadcoordinate2.Z)
           $d= [System.Numerics.Vector3]::new($roadcoordinate2.X1,$roadcoordinate2.Y1,$roadcoordinate2.Z1)
           $v=$a-$b 
           $u =$c-$d
            $n=  [System.Numerics.Vector3]::new($v.y*$u.z-$u.z*$v.y,$v.z*$u.x-$v.x*$u.z,$v.x*$u.y-$v.y*$u.x)
            <#
            $m1=  [System.Numerics.Vector3]::new($v.y*$n.z-$v.z*$n.y,$v.z*$n.x-$v.x*$n.z,$v.x*$n.y-$v.y*$n.x)
            $m2= [System.Numerics.Vector3]::new($u.y*$n.z-$u.z*$n.y,$u.z*$n.x-$u.x*$n.z,$u.x*$n.y-$u.y*$n.x)
               $C1 =  [System.Numerics.Plane]::new($M1,$D1)
            $C2=[System.Numerics.Plane]::new($m2,$d2)
                        $d1 = -($m1.x*$P1.x+$m1.y*$P1.y+$m1.z*$P1.z)
            $d2=  -($m2.x*$P2.x+$m2.y*$P2.y+$m2.z*$P2.z)
            #>
            ### 求过法线平面C1,C2
            $P1 =$A
            $p2=$C
            <#
            根据 AX+BY+CZ+D=0
            
            求D
            #>
            $d1=-($u.x*$P1.x+$u.y*$P1.y+$u.z*$P1.z)
            $d2= -($v.x*$P2.x+$v.y*$P2.y+$v.z*$P2.z)
            <#
            因为$u，$v 分别为平面C2,C1的法线
            根据点法式求平面方程
            #>

            

            ### 求点积确定方向
$ca=$v.x*$a.x+$v.y*$a.y+$v.z*$a.z
$cb=$v.x*$b.x+$v.y*$b.y+$v.z*$b.z
$cc=$u.x*$c.x+$u.y*$c.y+$u.z*$c.z
$cd=$u.x*$d.x+$u.y*$d.y+$u.z*$d.z

            $c1 =$ca*$cb
            $c2 =$cc*$cd

            
###  求解线段AB，CD 是否在C2,C1平面异侧，若C,D位于平面C1的异侧，且A,B位于平面C2的异侧则：
if ($c1 -lt 0 -and $c2 -lt 0) {
######  计算公垂线

     

                <#线段 AB
，CD
 之间距离为： AC→
 （A
 可替换为线段 AB
 上任意一点，C
 可替换为线段 CD
 上任意一点）在法向量 n⃗ 
 上的投影。（证明略）#>    
$P1P2=$p2-$P1

$distance=[math]::abs( [System.Numerics.Vector3]::Dot($p1p2,$n)/[math]::Sqrt([System.Numerics.Vector3]::Dot($n,$n)))


<#计算垂足#>
$t1=0
$t2=0
$a1= [System.Numerics.Vector3]::dot($v,$u)
$b1 =[System.Numerics.Vector3]::dot($v,$v)
$c1wtk= [System.Numerics.Vector3]::dot($u,$u )

$d1=[System.Numerics.Vector3]::dot(($p1p2),$v)
$e1=[System.Numerics.Vector3]::dot(($p1p2),$u)
switch ($a1) {
    #垂直的情况s
    0 { 
        $t1= $d1/$b1
        $t2=-$e1/$c1wtk

     }
    Default {
        if (($a1*$a1-$b1*$c1wtk -eq 0 )) {
            return "//"
        }
        else {
        
            $t1=($a1*$e1-$c1wtk*$d1)/($a1*$a1-$b1*$c1wtk)
            $t2=$b1/$a1*$t1-$d1/$a1
        }



    }

}
$startvertex=$p1+$t1*$v
$endvertex=$p2+$t2*$u
return [edge]::new($startvertex,$endvertex,$distance)

}


    

#若不满足上一条件则:
         else {
   ###### min(dis(A,CD),dis(B,CD),dis(C,AB),dis(D,AB))
   $a =[place]::new(($a.x,$a.y,$a.z))
   $b =[place]::new(($b.x,$b.y,$b.z))
   $c =[place]::new(($c.x,$c.y,$c.z))
   $d =[place]::new(($d.x,$d.y,$d.z))
   $MinDis = ([road]::calcroute($a,$road2)),([road]::calcroute($b,$road2)),([road]::calcroute($c,$road1)),([road]::calcroute($d,$road1))|Sort-Object -Property weight |select-object -first 1
   return $MinDis,$a,$b,$c,$d,$road1,$road2
         


         }   
         
         

        }   

###### main GPS parameter holder class


 






    static[object]calcroute ([place]$myplace,[place]$destination){
$mycoordinate = $myplace.placecoordinate
$destinationcoordinate =$destination.placecoordinate
$weight =[math]::sqrt(($mycoordinate.x-$destinationcoordinate.x)*($mycoordinate.x-$destinationcoordinate.x)+($mycoordinate.y-$destinationcoordinate.y)*($mycoordinate.y-$destinationcoordinate.y)+($mycoordinate.z-$destinationcoordinate.z)*($mycoordinate.z-$destinationcoordinate.z))

        $startvertex = $mycoordinate
        $endvertex = $destinationcoordinate
        return [edge]::new($startVertex,$endvertex,$weight)
           
    }
   

}


## main
class main {
    

    static [object]lineIntersect($roadcoordinate1,$roadcoordinate2)
    {

$A1=$roadcoordinate1.z1 - $roadcoordinate1.z
$B1=$roadcoordinate1.x- $roadcoordinate1.x1
$C1=$A1*$roadcoordinate1.x+$B1*$roadcoordinate1.y


$A2=$roadcoordinate2.z1-$roadcoordinate2.z
$B2=$roadcoordinate2.x-$roadcoordinate2.x1
$C2=$A2*$roadcoordinate2.x+$B2*$roadcoordinate2.y
if ( $A1*$B2 -eq $A2*$B1   ) {
    return $null
}    

return [psobject]@{

    x=($B2*$C1-$B1*$C2)/($A1*$B2-$A2*$B1)
    z=($A1*$C2-$A2*$C1)/($A1*$B2-$A2*$B1)
}
    } 



   static [bool]inline($placecoordinate,$roadcoordinate){
    if (($roadcoordinate.x..$roadcoordinate.x1).contains($placecoordinate.x) -and ($roadcoordinate.z..$roadcoordinate.z1).contains($placecoordinate.z))

    {
    return $true
    }   
    return $false

    }
    

    static [int]calc (  
        [psobject]$place1,
        [psobject]$place2)
    
            
            {
         
           


            return [math]::sqrt(($place1.x-$place2.x )*($place1.x-$place2.x)+($place1.y-$place2.y)*($place1.y-$place2.y)+($place1.z-$place2.z)*($place1.z-$place2.z))
           
          
            
            
            
            
    
    
        }


[object]static lineexpression (
    [psobject]$line
)
{   
    $linecoordinate = $line.roadcoordinate
$A=$linecoordinate.z1-$linecoordinate.z
$B=$linecoordinate.x-$linecoordinate.x1
$C=$A*$linecoordinate.x+$B*$linecoordinate.y

return @{
    A=$A
    B=$B
    C=$C
}

} 

static [System.Numerics.Vector3]normal_vector(
    [System.Numerics.Vector3]$vector1
    ,
    [System.Numerics.Vector3]$vector2


)
{
return $null

}
}

##  wynncraft_place class 
class wynncraft_place { 
    [placecoordinate]$placecoordinate
    [int]$id
    [place_type]$type

    
### construct
wynncraft_place ($properties){
    $this.DoInit($properties)
}
### Method   
#### DoInit
[void]DoInit ($value)
{ 
[int32]$attempt=-1
if ([int32]::TryParse($value,[ref]$attempt))
{
    $this.id=$attempt
}
else
{
    
    $this.type=$value
    $this.id=-1
}
}
[void]DoInit ([hashtable]$properties){

    foreach ($property in $properties.keys)
    {
        $this.$property=$properties.$property
    }
}
[void]DoInit ([array]$array){

    $this.placecoordinate=$array[0]
    $this.type=$array[1]
}
    #### validate method for repeat adding
static [void]validate ([wynncraft_place]$wynncraft_place,[int]$distance_limit){

$wynncraft_places=Import-clixml $PSScriptRoot\xml\wynncraft_places.xml|Where-Object {$_.type -like $wynncraft_place.type}



$wynncraft_places|foreach-object {

    

$distance = [main]::calc($wynncraft_place.placecoordinate,$_.placecoordinate)

    if ($distance -lt $distance_limit) {
        throw "重复坐标"
    }


}

}   






}


## class for survival_place
class survival_place {
  [placecoordinate]$placecoordinate
    [dimension]$dimension
    [place_type]$type
    [int]$id

    ### construct 
survival_place ($properties) {

    $this.DoInit($properties)
}
    
    ### Method
#### DoInit
[void]DoInit ($value){ 
    [int32]$attempt=-1
    if ([int32]::TryParse($value,[ref]$attempt))
    {
        $this.id=$attempt
    }
    else
    {   
        $this.id  =-1
        $this.type=$value
    }
}
#### Doinit
[void]DoInit ([hashtable]$properties){

    ForEach($property IN $properties.keys) {
        $this.$property=$properties.$property
    }
}
[void]DoInit ([array]$array){
##### with placecooridnate
    if ($array.count -eq 3) {
        $this.placecoordinate =$array[0]
        $this.dimension=$array[1]
        $this.type=$array[2]
        
    }
    ##### without placecoordinate
    elseif ($array.count -eq 2) {
        $this.dimension =$array[0]
        $this.type=$array[1]
    }
}

#### validation mathod for repeat adding
   static [void]validate ([survival_place]$survival_place,[int]$distance_limit){
        $survival_places = Import-clixml $PSScriptRoot\xml\survival_places.xml|Where-Object {$_.type -like $survival_place.type -and $_.dimension -like $survival_place.dimension}
    
      $survival_places|foreach-object {
       $distance= [main]::calc($survival_place.placecoordinate,$_.placecoordinate)

        if ($distance -lt $distance_limit) {
            throw "坐标重复"
        }
        
      }


    }

}
## teleportation_place
class teleportation_place {
  [placecoordinate]$placecoordinate
    [int]$id
    [string]$name
    ### construct 
     teleportation_place ($properties){

        $this.Doinit($properties)
     }
### Method
#### DoInit
[void]DoInit ($value){ 
    [int32]$attempt=-1
    if ([int32]::TryParse($value,[ref]$attempt))
    {
        $this.id=$attempt
    }
    else
    {
        $this.name=$value
        $this.id=-1
    }
    
}   
#### DoInit         
[void]DoInit ([hashtable]$properties){
    foreach ($property in $properties.keys){
        $this.$property=$properties.$property
        
    }
}
#### DoInit 
[void]DoInit ([array]$array){
    $this.placecoordinate=$array[0]
    $this.name =$array[1]
}
    ### validate method for repeat adding

   static [void] validate([teleportation_place]$teleportation_place,[int]$distance_limit) 
    
    {

        $teleportation_places=Import-clixml $PSScriptRoot\teleportation_places.xml|Where-Object($_.type -eq $teleportation_place.type)
        $distance_limit=50
  
        $teleportation_places| foreach-object {


            $distance=[main]::calc($teleportation_place.placecoordinate,$_.placecoordinate)


            if ($distance -lt $distance_limit) {
                throw "坐标重复"
            }
        }

       
    }

    ### calc method for calc the teleportation route between destination and teleportation places
static [hashtable]calcroute (
    [placecoordinate]$mycoordinate
    ,
    [psobject]$teleportation_place
    )
    {
    
        $distance = [main]::calc($mycoordinate,$teleportation_place.placecoordinate)
        
    
        return @{
            distance=$distance
            name=$teleportation_place.name
        }
    
    
    }


}




## enum holder  placetype for parameter 



enum place_type {
    
    null
    blackSmith
    scroll_merchant
    farm
    fishing
    tool_merchant
    mine
    identifier
    bank
    chest
    powder_master
    housing
 
    boat 
    woodland_mansion
    ocean_mountain
    pillager_outpost
    village
    portal
    fortress
    slime_chunk
    ravine
    ocean_ruins
    fossil
    Trail_Ruins
    roads
    stronghold
    Ancient_City
    Desert_Temple
    lgloo
    Biomes
    mineshaft
    shipwreck
    cave
    lava_pool
    Geode
    apple
    ore_veins
    Derset_wellwitch_hut
    nether_portal
    Trade_Market
    potion_merchant

}
   







## dimension parameter enum holder 
enum dimension{ 
null
nether
the_end
overworld

}
