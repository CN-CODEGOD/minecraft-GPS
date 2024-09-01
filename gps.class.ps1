 using namespace system.xml.linq
 . "C:\Users\34683\BFS\graph.class.ps1"
# basic CLASS



## element class for line coordinate
class roadcoordinate {
[System.Numerics.Vector3]$roadcoordinate1
[System.Numerics.Vector3]$roadcoordinate2

roadcoordinate ($value){
$this.DoInit($value)
}
roadcoordinate ([System.Numerics.Vector3]$roadcoordinate1,[System.Numerics.Vector3]$roadcoordinate2){
    $this.roadcoordinate1=$roadcoordinate1
    $this.roadcoordinate2=$roadcoordinate2
}


### validation
[void]DoInit ([pscustomobject]$pscustomobject){
     $pscustomobjectName= (($pscustomobject)|Get-Member -Type NoteProperty ).Name
        foreach($propertyName in $pscustomobjectName ){

           $this.$Propertyname= $pscustomobject.$Propertyname
        }

}

[void] DoInit (


[hashtable]$properties


)
{
    foreach ($property in $properties.key) {

        $this.$property =$properties.$property
    }
}

}


# advance class
## place 
class place { 

    [System.Numerics.Vector3]$placecoordinate
    [string]$id="O"
    place ($value){
        $this.DoInit($value)
    }
   place ([System.Numerics.Vector3]$placecoordinate){
$this.DoInit($placecoordinate,"O")
   }
  place ([System.Numerics.Vector3]$placecoordinate,[string]$id){
$this.DoInit($placecoordinate,$id)

  }


[void]DoInit([System.Numerics.Vector3]$placecoordinate,[string]$id){

    $this.placecoordinate=$placecoordinate
    $this.id=$id
}
   
    [void]Doinit([pscustomobject]$pscustomobject){
        $pscustomobjectName= (($pscustomobject)|Get-Member -Type NoteProperty ).Name
        foreach($propertyName in $pscustomobjectName ){

           $this.$Propertyname= $pscustomobject.$Propertyname
        }
    }
}
## road
class road {

    [roadcoordinate]$roadcoordinate
    [string]$name
    [dimension]$dimension
    [int]$id
    hidden $path="$PSScriptRoot\xml\roads.xml"
### construct





road ($value) {

    $this.DoInit( $value)


}
road([roadcoordinate]$roadcoordinate,[string]$name,[dimension]$dimension,[int]$id){

    $this.DoInit($roadcoordinate,$name,$dimension,$id)
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
[void] DoInit(    [pscustomobject]$pscustomobject){
        $pscustomobjectName= (($pscustomobject)|Get-Member -Type NoteProperty ).Name
        foreach($propertyName in $pscustomobjectName ){

           $this.$Propertyname= $pscustomobject.$Propertyname
        }
    }
[void] DoInit (


[hashtable]$properties


)
{
    foreach ($property in $properties.key) {

        $this.$property =$properties.$property
    }
}
[void]DoInit ([roadcoordinate]$roadcoordinate,[string]$name,[dimension]$dimension,[int]$id){

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
[object] save(){
    
    $object = [xelement]::new("object",[System.Xml.Linq.XAttribute]::new("type","road"),
        [xelement]::new("property",[XAttribute]::new("name","roadcoordinate"),
            [xelement]::new("property",[XAttribute]::new("name","roadcoordinate1"),
                [xelement]::new("property",[XAttribute]::new("name","x"),$this.roadcoordinate.roadcoordinate1.X),
                [xelement]::new("property",[XAttribute]::new("name","y"),$this.roadcoordinate.roadcoordinate1.Y),
                [xelement]::new("property",[XAttribute]::new("name","z"),$this.roadcoordinate.roadcoordinate1.Z)
            ),
          [xelement]::new("property",[XAttribute]::new("name","roadcoordinate2"),
                [xelement]::new("property",[XAttribute]::new("name","x"),$this.roadcoordinate.roadcoordinate2.X),
                [xelement]::new("property",[XAttribute]::new("name","y"),$this.roadcoordinate.roadcoordinate2.Y),
                [xelement]::new("property",[XAttribute]::new("name","z"),$this.roadcoordinate.roadcoordinate2.Z)
            )

        ),
        [xelement]::new("property",[XAttribute]::new("name","name"),$this.name),
        [xelement]::new("property",[XAttribute]::new("name","dimension"),$this.dimension),
        [xelement]::new("property",[XAttribute]::new("name","id"),$this.id)
    )
    return $object.tostring()
}
static [psobject]calcroute ( 
    [System.Numerics.Vector3]$placecoordinate
    ,
    [road]$road
    
 
    
    )
    { 
        #default distance
    $distance = [double]::PositiveInfinity
    
    
    
        
        $a =$road.roadcoordinate.roadcoordinate1 
        $b =$road.roadcoordinate.roadcoordinate2
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
        
       $distance=[System.Numerics.Vector3]::distance($placecoordinate,$projectedpoint)
        
    
    }
    
    elseif ($r -lt 0) {
        $projectedpoint =$a
    
        $distance=[System.Numerics.Vector3]::distance($placecoordinate,$projectedpoint)
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
 $y =$placecoordinate.y   
}

$y = -($projectedpoint.X*$A+$projectedpoint.Y*$C+$D)/$B







        
        $projectedpoint=[System.Numerics.Vector3]::new($projectedpoint.x,$y,$projectedpoint.y)
        
        $distance=[System.Numerics.Vector3]::distance($projectedpoint,$placecoordinate)
        
    
}
    
    $startvertex = $placecoordinate
    $endvertex =$projectedpoint
    return [edge]::new($startVertex,$endvertex,$distance)
         
    
        
            }
        #### calcroute 
        <#
        ## calc method for calc road route between destination and road road ==> Placecoordinate
        #>
static [psobject]calcroute ( 
    [road]$road
    ,
    [System.Numerics.Vector3]$placecoordinate
    
    )
    { 
        #default distance
    $distance = [double]::PositiveInfinity
    
    
    
        
        $a =$road.roadcoordinate.roadcoordinate1 
        $b =$road.roadcoordinate.roadcoordinate2
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
        
       $distance=[System.Numerics.Vector3]::distance($placecoordinate,$projectedpoint)
        
    
    }
    
    elseif ($r -lt 0) {
        $projectedpoint =$a
    
        $distance=[System.Numerics.Vector3]::distance($placecoordinate,$projectedpoint)
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
 $y =$placecoordinate.y   
}

$y = -($projectedpoint.X*$A+$projectedpoint.Y*$C+$D)/$B







        
        $projectedpoint=[System.Numerics.Vector3]::new($projectedpoint.x,$y,$projectedpoint.y)
        
        $distance=[System.Numerics.Vector3]::distance($projectedpoint,$placecoordinate)
        
    
}
    
    $startvertex = $projectedpoint
    $endvertex =$placecoordinate
    return [edge]::new($startVertex,$endvertex,$distance)
         
    
        
            }
    
### calcroute
        static[object] calcroute([road]$roadA,[road]$roadB) {

            ###### default projectedpoints
            $projectedpoints=[edge]::new($null,$null)
            
           
           
           $a=$roadA.roadcoordinate.roadcoordinate1
           $b= $roadA.roadcoordinate.roadcoordinate2
           $c=$roadB.roadcoordinate.roadcoordinate1
           $d= $roadB.roadcoordinate.roadcoordinate2
           $v=$a-$b 
           $u =$c-$d
            $n=  [System.Numerics.Vector3]::new($v.y*$u.z-$v.z*$u.y,$v.z*$u.x-$v.x*$u.z,$v.x*$u.y-$v.y*$u.x)
            <#
所以CD是C1的法向量，C1为过点A且法向量为m1的平面
设平面C1=A(x-Xa)+B(y-Ya)+C(z-Za)
M1=(Ny*Vz-Nz*Vy,Nz*Vx-Nx*Vz,Nx*Vy-Ny*Vx)=（Xm1，Ym1，Zm1）
A=Xm1
B=Ym1
C=Zm1


求出过线段CD,且平行与n的平面C2，并判断A，B是否位于C2异侧
因为n是AB，CD的公共法向量
所以AB是C2的法向量，C2为过点C且法向量为m2的平面
设平面C2=A(x-Xc)+B(y-Yc)+C(z-Zc)
M1=(Ny*Uz-Nz*Uy,Nz*Ux-Nx*Uz,Nx*Uy-Ny*Ux)=（Xm2，Ym2，Zm2·）
A=Xm2
B=Ym2
C=Zm2

#>
            $m1=  [System.Numerics.Vector3]::new($v.y*$n.z-$v.z*$n.y,$v.z*$n.x-$v.x*$n.z,$v.x*$n.y-$v.y*$n.x)
            $m2= [System.Numerics.Vector3]::new($u.y*$n.z-$u.z*$n.y,$u.z*$n.x-$u.x*$n.z,$u.x*$n.y-$u.y*$n.x)

            
$C1_C=$m1.X*($C.X-$A.X)+$m1.y*($C.Y-$A.Y)+$M1.Z*($C.Z-$A.Z)            
$C1_D=$m1.X*($D.X-$A.X)+$m1.y*($D.Y-$A.Y)+$M1.Z*($D.Z-$A.Z)            
$C2_A=$m2.x*($A.x-$C.x)+$m2.y*($A.y-$C.y)+$m2.z*($A.z-$C.z)
$C2_B=$m2.x*($B.x-$C.x)+$m2.y*($B.y-$C.y)+$m2.z*($B.z-$C.z)      
$C1_CD=$C1_C*$C1_D
$C2_AB=$C2_A*$C2_B
            <#
            根据 AX+BY+CZ+D=0
            
       
      
            



            
###  1：若C1(C) *C1(D)<0则CD异侧，否则C，D同侧#>    
if ($C1_CD -lt 0 -and $C2_AB -lt 0) {
<#AB，CD的最短距离为，AC向量（A可替换为AB上任意一点，C可替换为CD上任意一点）#>


$distance=[math]::abs( [System.Numerics.Vector3]::Dot(($C-$A),$n)/[math]::Sqrt([System.Numerics.Vector3]::Dot($n,$n)))


<#计算垂足#>


$a=[System.Numerics.Vector3]::DOT($U,$V)

$b=[System.Numerics.Vector3]::DOT($V,$V)


$c=[System.Numerics.Vector3]::DOT($U,$U)
$d=[System.Numerics.Vector3]::dot(($c-$a),$v)

$e=[System.Numerics.Vector3]::Dot(($c-$a),$u)
## AB,CD 垂直的情况
if ($a -eq 0) {
$xd1= $d/$b
$xd2= -$e/$c
$d1 =$A+$xd1*$V
$d2=$C+$xd2*$U
$startVertex=new-object vertex $d1 
$endvertex=new-object vertex $d2

return [edge]::new($startVertex,$endvertex,$distance)
}

else {
if(($a*$a-$b*$c) -ne  0){
$xd1= ($a*$e-$c*$d)/($a*$a-$b*$c)
$xd2= ($b/$a*$xd1-$d/$a)
$d1 =$A+$xd1*$V
$d2=$C+$xd2*$U
$startVertex=new-object vertex $d1 
$endvertex=new-object vertex $d2

return [edge]::new($startVertex,$endvertex,$distance)
}
##AB，CD平行的情况
else {
return [edge]::new($null,$null,$distance)
}

}

}


    

#若不满足上一条件则:
         else {
   ###### min(dis(A,CD),dis(B,CD),dis(C,AB),dis(D,AB))
  
   $MinDis = ([road]::calcroute($A,$roadB)),([ROAD]::calcroute($B,$roadB))
   return $MinDis[0]
         


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
    [System.Numerics.Vector3]$placecoordinate
    [int]$id
    [place_type]$type

    
### construct
wynncraft_place ($value){
    $this.DoInit($value)
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
[void]DoInit ([pscustomobject]$pscustomobject){
        $pscustomobjectName= (($pscustomobject)|Get-Member -Type NoteProperty ).Name
        foreach($propertyName in $pscustomobjectName ){

           $this.$Propertyname= $pscustomobject.$Propertyname
        }
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
  [System.Numerics.Vector3]$placecoordinate
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
[void]DoInit ([pscustomobject]$pscustomobject){
        $pscustomobjectName= (($pscustomobject)|Get-Member -Type NoteProperty ).Name
        foreach($propertyName in $pscustomobjectName ){

           $this.$Propertyname= $pscustomobject.$Propertyname
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
  [System.Numerics.Vector3]$placecoordinate
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
[void]DoInit ([pscustomobject]$pscustomobject){
        $pscustomobjectName= (($pscustomobject)|Get-Member -Type NoteProperty ).Name
        foreach($propertyName in $pscustomobjectName ){

           $this.$Propertyname= $pscustomobject.$Propertyname
        }
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
    [System.Numerics.Vector3]$mycoordinate
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
