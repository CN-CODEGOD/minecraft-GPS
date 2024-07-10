#element class for point coordinate



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
#element class for line coordinate
class roadcoordinate {
[int]$x
[int]$y
[int]$z
[int]$x1    
[int]$y1
[int]$z1
roadcoordinate([array]$roadcoordinate){

    $this.x=$roadcoordinate[0]
    $this.y=$roadcoordinate[1]
    $this.z=$roadcoordinate[2]
    $this.x1=$roadcoordinate[3]
    $this.y1=$roadcoordinate[4]
    $this.z1=$roadcoordinate[5]
}
}


class road {

    [roadcoordinate]$roadcoordinate
    [string]$name
    [dimention]$dimention
    [int]$id
static [void]validate([road]$road){

    $roads =Import-clixml c:\ex-sys\xml\roads.xml
$roads| foreach-object { 


if (($_.roadcoordinate.x..$_.roadcoordinate.x1).contains($road.roadcoordinate.x) -and ($_.roadcoordinate.x..$_.roadcoordinate.x1).contains($road.roadcoordinate.x1) -and ($_.roadcoordinate.y..$_.roadcoordinate.y1).contains($road.roadcoordinate.y) -and ($_.roadcoordinate.y..$_.roadcoordinate.y1).contains($road.roadcoordinate.y1) -and ($_.roadcoordinate.z..$_.roadcoordinate.z1).contains($road.roadcoordinate.z) -and ($_.roadcoordinate.z..$_.roadcoordinate.z1).contains($road.roadcoordinate.z1)) 
{
throw "路线重叠"
}   

}

    
}

#search method for road 
static[psobject] searchplace(
[placecoordinate]$mycoordinate
,
[psobject]$roadcoordinate



)
{ 
    $projectedpoint=([road]::calcroute($mycoordinate,$roadcoordinate)).projectedpoint
    $distance=[main]::calc($mycoordinate,$projectedpoint)

    
    return  @{

        distance=$distance
        projectedpoint=$projectedpoint
        
    }

}

## calc distance between road and road 
## calc method for calc road route between destination and road
static [psobject]calcroute ( 
[placecoordinate]$placecoordinate
,
[psobject]$road

)
{ 
    #default distance
$distance = [double]::PositiveInfinity

$roadcoordinatewtk=$road.roadcoordinate

    
    $a = @{
        x=$roadcoordinatewtk.x
      
        z=$roadcoordinatewtk.z
    }
    $b = @{x= $roadcoordinatewtk.x1
    
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





    
if ($r -gt 0 -and $r -lt 1) {
    $projectedpoint= $oa+$v*$r
    $distance=[math]::sqrt([math]::pow(($projectedpoint.x-$placecoordinate.x),2)+[math]::pow(($projectedpoint.y-$placecoordinate.z),2))

    
}

elseif ($r -gt 1) {
    $projectedpoint=$b
    
    $distance=[math]::sqrt([math]::pow(($projectedpoint.x-$placecoordinate.x),2)+[math]::pow(($projectedpoint.z-$placecoordinate.z),2))

}

elseif ($r -lt 0) {
    $projectedpoint =$a
    $distance=[math]::sqrt([math]::pow(($projectedpoint.x-$placecoordinate.x),2)+[math]::pow(($projectedpoint.z-$placecoordinate.z),2))
    
}







return @{
    roadcoordinate=$road.roadcoordinate
    id=$road.id
    projectedpoint=$projectedpoint
    distance=$DISTANCE
     }

    
        }


#main GPS parameter holder class

static[object] calcroute (
    [placecoordinate]$mycoordinate
    ,

    [placecoordinate]$destination
) {
$distance = [main]::calc($mycoordinate,$destination)
return @{

    distance=$distance
    projectedpoint=$destination
}


}


static [object] calcroute ( 
[psobject]$startroad,
[psobject]$endroad


)


{
    $startroadcoordinate=$startroad.roadcoordinate

    $endroadcoordinate=$endroad.roadcoordinate

$s0=[System.Numerics.Vector3]::new($startroadcoordinate.x,$startroadcoordinate.y,$startroadcoordinate.z)
$s1=[System.Numerics.Vector3]::new($startroadcoordinate.x1,$startroadcoordinate.y1,$startroadcoordinate.z1)
$t0=[System.Numerics.Vector3]::new($endroadcoordinate.x,$endroadcoordinate.y,$endroadcoordinate.z)
$t1=[System.Numerics.Vector3]::new($endroadcoordinate.x1,$endroadcoordinate.y1,$endroadcoordinate.z1)
#定义向量
$u = $s1-$s0
$v=$t1-$t0
$w0= $s0-$t0
#设a,b,c,d,e
$a = [System.Numerics.Vector3]::dot($u,$u)
$b= [System.Numerics.Vector3]::dot($u,$v)
$c=[System.Numerics.Vector3]::dot($v,$v)
$d=[System.Numerics.Vector3]::dot($u,$w0)
$e=[System.Numerics.Vector3]::dot($v,$w0)

#求s0，t0的标量,sc,tc


try{

    $sc= ($b*$e-$c*$d)/($a*$c-$b*$b)

    $tc=($a*$e-$b*$d)/($a*$e-$b*$b)
    
}


catch {
 $sc = 0
 $tc = $e/$c
}

$startroadprojectedpoint= $s0+$sc*$u
$endroadprojectedpoint =$t0+$sc*$v
return @{
startpoint=$startroadprojectedpoint
endpoint= $endroadprojectedpoint    
}
}

 





## parameter class construct for add-place -road with name
    road (


    
    [roadcoordinate]$roadcoordinate
    ,   
    [dimention]$dimention
    ,
    [string]$name
    )
    {
$this.roadcoordinate=$roadcoordinate
    $this.dimention=$dimention
    $this.name=$name


}

## parameter class construct for add-place -road without Name
road (


    
[roadcoordinate]$roadcoordinate
,   
[dimention]$dimention


)
{
$this.roadcoordinate=$roadcoordinate
$this.dimention=$dimention



}

    #paramter class construct for search-place -road and road-route -road

    road ([string]$value){ 
        [int32]$attempt=-1
        if ([int32]::TryParse($value,[ref]$attempt))
        {
            $this.id=$attempt
        }
        else
        {
            $this.dimention=$value
            $this.id=-1
        }
    }

   

}



class main {
    

    static [object]lineIntersect($roadcoordinate1,$roadcoordinate2){

$A1=$roadcoordinate1.z1 - $roadcoordinate1.z
$B1=$roadcoordinate1.x- $roadcoordinate1.x1
$C1=$A1*$roadcoordinate1.x+$B1*$roadcoordinate1.y


$A2=$roadcoordinate2.z1-$roadcoordinate2.z
$B2=$roadcoordinate2.x-$roadcoordinate2.x1
$C2=$A2*$roadcoordinate2.x+$B2*$roadcoordinate2.y
if ( $A1*$B2 -eq $A2*$B1   ) {
    return $null
}    

return [Ordered]@{

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
    
    
}

##  wynncraft_place class 
class wynncraft_place { 
    [placecoordinate]$placecoordinate
    [int]$id
    [place_type]$type

    
    ##validate method for repeat adding
static [void]validate ([wynncraft_place]$wynncraft_place,[int]$distance_limit){

$wynncraft_places=Import-clixml c:\ex-sys\xml\wynncraft_places.xml|Where-Object {$_.type -like $wynncraft_place.type}



$wynncraft_places|foreach-object {

    

$distance = [main]::calc($wynncraft_place.placecoordinate,$_.placecoordinate)

    if ($distance -lt $distance_limit) {
        throw "重复坐标"
    }


}

}   


##search method for searching place near player

static[psobject] searchplace(
[psobject]$mycoordinate,
[psobject]$wynncraft_place


)

{ 

    
   $distance = [main]::calc($mycoordinate,$wynncraft_place.placecoordinate)

return @{

   x=$wynncraft_place.placecoordinate.x
   y=$wynncraft_place.placecoordinate.y
   z=$wynncraft_place.placecoordinate.z
   distance=$distance
   type=$wynncraft_place.type
}
}

## parameter class construct for add-place -wynncraft_place
wynncraft_place ([placecoordinate]$placecoordinate,[place_type]$type) {

        $this.placecoordinate=$placecoordinate  
    $this.type =$type
}
## parameter class construct for search-place -wynncraft_place
wynncraft_place ([string]$value)
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

}


##class for survival_place
class survival_place {
  [placecoordinate]$placecoordinate
    [dimention]$dimention
    [place_type]$type
    [int]$id
#validation mathod for repeat adding
   static [void]validate ([survival_place]$survival_place,[int]$distance_limit){
        $survival_places = Import-clixml c:\ex-sys\xml\survival_places.xml|Where-Object {$_.type -like $survival_place.type -and $_.dimention -like $survival_place.dimention}
    
      $survival_places|foreach-object {
       $distance= [main]::calc($survival_place.placecoordinate,$_.placecoordinate)

        if ($distance -lt $distance_limit) {
            throw "坐标重复"
        }
        
      }


    }
    #search method for survival_places
    static[psobject] searchplace(
[placecoordinate]$mycoordinate,
[psobject]$survival_place


)

{ 

    
   $distance = [main]::calc($mycoordinate,$survival_place.placecoordinate)

return @{

   x=$survival_place.placecoordinate.x
   y=$survival_place.placecoordinate.y
   z=$survival_place.placecoordinate.z
   distance=$distance
   type=$survival_place.type
   dimention=$survival_place.dimention
}
}
    ## parameter class construct for add-place -survival_place
survival_place (
[placecoordinate]$placecoordinate
,
[dimention]$dimention
,
[place_type]$type

)


{

    $this.placecoordinate=$placecoordinate
    $this.dimention=$dimention
    $this.type=$type 
}

## parameter class construct for search-place -survival_place 
survival_place (
    [dimention]$dimention
    ,
    [place_type]$type
)
{
    $this.dimention=$dimention
    $this.type=$type

}
## parameter class construct for remove-place -survival_place  & find-place -survival_place

survival_place ([string]$value){ 
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

}
class teleportation_place {
  [placecoordinate]$placecoordinate
    [int]$id
    [string]$name
    #validate method for repeat adding
   static [void] validate([teleportation_place]$teleportation_place,[int]$distance_limit) 
    
    {

        $teleportation_places=Import-clixml c:\ex-sys\xml\teleportation_places.xml|Where-Object($_.type -eq $teleportation_place.type)
        $distance_limit=50
  
        $teleportation_places| foreach-object {


            $distance=[main]::calc($teleportation_place.placecoordinate,$_.placecoordinate)


            if ($distance -lt $distance_limit) {
                throw "坐标重复"
            }
        }

       
    }
    ## method for searching teleportation_place near player

static[psobject] searchplace(
    [placecoordinate]$mycoordinate,
    [psobject]$teleportation_place
    
    
    )
    
    { 
    
        
       $distance = [main]::calc($mycoordinate,$teleportation_place.placecoordinate)
    
    return @{
    
       x=$teleportation_place.placecoordinate.x
       y=$teleportation_place.placecoordinate.y
       z=$teleportation_place.placecoordinate.z
       distance=$distance
       name=$teleportation_place.name
    }
    }
    ##calc method for calc the teleportation route between destination and teleportation places
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
    ## parameter class construct for add-place -teleportation_place
    teleportation_place (
   [placecoordinate]$placecoordinate
        ,
    [string]$name
    ) {
       $this.placecoordinate=$placecoordinate
        $this.name=$name
    
    }
    ## parameter class construct for remove-place and find-place -teleportation_place 

    
    teleportation_place ([string]$value){ 
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

}
##class holder maplist for parameter 

Class maplist : System.Management.Automation.IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        $maplist = (get-childitem c:\ex-sys\xml\gps ).basename
        return [string[]] $maplist
  }
}




##enum holder  placetype for parameter 






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
   







#dimention parameter enum holder 
enum dimention{ 
null
nether
the_end
overworld

}
