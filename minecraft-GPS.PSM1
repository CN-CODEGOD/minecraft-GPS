




using namespace system.xml.linq

# basic CLASS


class graph {
    
   $vertices
   $edges
   [bool]$isDirected
   Graph () {
       $this.DoInit($false)
   }
       
   Graph ($isDirected) {
       $this.DoInit($isDirected)
   }
   
   DoInit($isDirected) {
       $this.vertices = [hashtable]@{}
       $this.edges = [Ordered]@{}
       $this.isDirected = $isDirected
   }
   [object] getVertexByKey($vertexKey) {
       return $this.vertices[$vertexKey]
   }
   

   [object] addVertex($newVertex) {
       $this.vertices[$newVertex.getKey()] = $newVertex
       return $this
   }
   
   [void] addEdge($edge) {
         # Try to find and end start vertices.
         $startVertex = $this.getVertexByKey($edge.startVertex.getKey())
         $endVertex = $this.getVertexByKey($edge.endVertex.getKey())
 
   
       # Insert start vertex if it wasn't inserted.
       if (!$startVertex) {
           $this.addVertex($edge.startVertex)
           $startVertex = $this.getVertexByKey($edge.startVertex.getKey())
       }
   
       # Insert end vertex if it wasn't inserted.
       if (!$endVertex) {
           $this.addVertex($edge.endVertex)
           $endVertex = $this.getVertexByKey($edge.endVertex.getKey())
       }
       
       if ($this.isDirected) {
           # If graph IS directed then add the edge only to start vertex.
           $startVertex.addEdge($edge)
       }
       else {
           # If graph ISN'T directed then add the edge to both vertices.
           $startVertex.addEdge($edge)
           $endVertex.addEdge($edge)
       }
     
       
                   # Check if edge has been already added.
                   if ($this.edges[$edge.getKey()]) {
                   throw 'Edge has already been added before'
                   }
                   else {
                       $this.edges[$edge.getKey()] =$edge
                   }
   
       
   }
   
   [object[]] getAllVertices() {
       return $this.vertices.values
   }
   [object] getNeighbors($vertex) {
       return $vertex.getNeighbors()
   }
   [object] findEdge($startVertex, $endVertex) {
       $vertex = $this.getVertexByKey($startVertex.getKey())
       return $vertex.findEdge($endVertex)
   }

   
   }
   
   class edge {
   
       $startVertex
       $endVertex
       $weight
   
   
       edge (  
           $startVertex
           ,
           $endVertex
      
       ){
   
           $this.startVertex=$startVertex
           $this.endVertex=$endVertex
           $this.weight=$null
        
       
       }

       edge (  
           $startVertex
           ,
           $endVertex
           ,
           $weight
      
       ){
   
           $this.startVertex=$startVertex
           $this.endVertex=$endVertex
           $this.weight=$weight
        
       
       }

    

    


       [object] getKey() {
           $startVertexKey = $this.startVertex.getKey()
           $endVertexKey = $this.endVertex.getKey()
   
           return "$($startVertexkey)_$($endVertexkey)"
           # return `${startVertexKey}_${endVertexKey}`;
       }
       }   
   class vertex {
       $value
       $edges
       Vertex() {
           $this.DoInit($null)
       }
   
       Vertex($value) {
           $this.DoInit($value)
       }
       hidden DoInit($value) {
           if (        $value -eq $null) {
               throw 'Graph vertex must have a value'
           }
   
   
           # Normally you would store string value like vertex name.
           # But generally it may be any object as well
           $this.value = $value
           $this.edges=New-Object System.Collections.Generic.LinkedList[object]
           
       }
   
       
       [object] addEdge($edge) {
           $this.edges.add($edge)
   
           return $this
       }
       [object] getNeighbors() {
           $targetEdges = $this.edges.ForEach({$_})
   
               $neighborsConverter = {
                   param($node)
   
                   if ($node.startVertex.getKey() -eq $this.getKey()) {
                       return $node.endVertex
                   }   
   
                   return $node.startVertex
               }
   
           # Return either start or end vertex.
           # For undirected graphs it is possible that current vertex will be the end one.
           return @($targetEdges.ForEach{&$neighborsConverter $_})
       }
       [object] getKey() {
           return $this.value.id 
       }
       [object] findEdge($vertex) {
    
           $edgeFinder ={
               param($edge)
     
               return $edge.startVertex -eq $vertex -Or $edge.endVertex -eq $vertex
           }
           
           
               $targetedges=$this.edges
               
               $currentNode = $targetedges.First
   
               while ($currentNode) {  
                   
               
               if (& $edgeFinder $currentNode.value) {
                   if($currentNode) {
                       return $currentNode.value
                     }
               
                     return $null
               }
               $currentNode = $currentNode.next
           }
               return $null
   }
   
   }

   
   <#


   .   
.     .
   |
   |
   |
   | class for graph
   #>


## element class for line coordinate
class roadcoordinate {
[System.Numerics.Vector3]$roadcoordinate1
[System.Numerics.Vector3]$roadcoordinate2

roadcoordinate ($value){
$this.DoInit($value)
}
roadcoordinate ([System.Numerics.Vector3]$roadcoordinate1,[System.Numerics.Vector3]$roadcoordinate2)
{
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


class placecoordinate {
 [System.Numerics.Vector3]$placecoordinate
 placecoordinate([array]$coordinate){
   $this.Doinit($coordinate)
 }
 [void]Doinit([array]$input){

$this = [System.Numerics.Vector3]::new(1,2,3)  
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
<#
calcroute for graph.ps1 calc place - road
#>
static [psobject]calcroute ( 
   [place]$placecoordinate
   ,
   [road]$road
   
   )
   { 
       #default distance
   $distance = [double]::PositiveInfinity
   
   
   
       
       $a =$road.roadcoordinate.roadcoordinate1 
       $b =$road.roadcoordinate.roadcoordinate2
       $p = $placecoordinate.placecoordinate

   $v= $b-$a
   $u = $p-$a
   $r = ([System.Numerics.Vector3]::dot($u,$v))/([System.Numerics.Vector3]::dot($v,$v))

   
   
   
   
       
   
   if ($r -gt 1) {
       $projectedpoint=$b
       
      $distance=[System.Numerics.Vector3]::distance($p,$projectedpoint)
       
   
   }
   











      
   
   elseif ($r -lt 0) {
       $projectedpoint =$a
   
       $distance=[System.Numerics.Vector3]::distance($p,$projectedpoint)
   }
   
else {

       $projectedpoint= $a+$v*$r
   
       $distance = [System.Numerics.Vector3]::distance($p,$projectedpoint)
          ### calc plane from coordinate

       




       
   
}
   
   $startvertex = $p
   $endvertex =$projectedpoint
   return [edge]::new($startVertex,$endvertex,$distance)
        
   
       
           }
   <#
   method:calcroute
   [road] - [place]
   calc the graph weight with place and road
   #>
   static [psobject]calcroute ( 
      [road]$road
      ,
      [place]$placecoordinate
      
      )
      { 
          #default distance
      $distance = [double]::PositiveInfinity
      
      
      
          
          $a =$road.roadcoordinate.roadcoordinate1 
          $b =$road.roadcoordinate.roadcoordinate2
          $p = $placecoordinate.placecoordinate
   
      $v= $b-$a
      $u = $p-$a
      $r = ([System.Numerics.Vector3]::dot($u,$v))/([System.Numerics.Vector3]::dot($v,$v))
   
      
      
      
      
          
      
      if ($r -gt 1) {
          $projectedpoint=$b
          
         $distance=[System.Numerics.Vector3]::distance($p,$projectedpoint)
          
      
      }
      
   
   
   
   
   
   
   
   
   
   
   
         
      
      elseif ($r -lt 0) {
          $projectedpoint =$a
      
          $distance=[System.Numerics.Vector3]::distance($p,$projectedpoint)
      }
      
   else {
   
          $projectedpoint= $a+$v*$r
      
          $distance = [System.Numerics.Vector3]::distance($p,$projectedpoint)
             ### calc plane from coordinate
   
          
   
   
   
   
          
      
   }
      
      $startvertex = $projectedpoint
      $endvertex =$p
      return [edge]::new($startVertex,$endvertex,$distance)
           
      
          
              }
           <#
           method:calcroute
           [placecoordinate] - [road]
           used to calc the distance from road to placecoordinate
           #>
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
         
            $v= $b-$a
            $u = $p-$a
            $r = ([System.Numerics.Vector3]::dot($u,$v))/([System.Numerics.Vector3]::dot($v,$v))
         
            
            
            
            
                
            
            if ($r -gt 1) {
                $projectedpoint=$b
                
               $distance=[System.Numerics.Vector3]::distance($p,$projectedpoint)
                
            
            }
            
         
         
         
         
         
         
         
         
         
         
         
               
            
            elseif ($r -lt 0) {
                $projectedpoint =$a
            
                $distance=[System.Numerics.Vector3]::distance($p,$projectedpoint)
            }
            
         else {
         
                $projectedpoint= $a+$v*$r
            
                $distance = [System.Numerics.Vector3]::distance($p,$projectedpoint)
                   ### calc plane from coordinate
         
                
         
         
         
         
                
            
         }
            
            $startvertex = $p
            $endvertex =$projectedpoint
            return [edge]::new($startVertex,$endvertex,$distance)
                 
            
                
                    }
     <#
    method:calcroute
    [road] [placecoordinate]
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
       
      $distance=[System.Numerics.Vector3]::distance($p,$projectedpoint)
       
   
   }
   
   elseif ($r -lt 0) {
       $projectedpoint =$a
   
       $distance=[System.Numerics.Vector3]::distance($p,$projectedpoint)
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
$y =$p.y   
}

$y = -($projectedpoint.X*$A+$projectedpoint.Y*$C+$D)/$B







       
       $projectedpoint=[System.Numerics.Vector3]::new($projectedpoint.x,$y,$projectedpoint.y)
       
       $distance=[System.Numerics.Vector3]::distance($projectedpoint,$p)
       
   
}
   
   $startvertex = $projectedpoint
   $endvertex =$placecoordinate
   return [edge]::new($startVertex,$endvertex,$distance)
        
   
       
           }
   
           <#
           method:calcroute 
           [road] [road]
           used to calc the distance between road and road
           #>
### calcroute
       static[object] calcroute([road]$roadA,[road]$roadB) {

           ###### default projectedpoints
           $projectedpoints=[edge]::new($null,$null)
           
          
          
          $roadcoordinateA=$roadA.roadcoordinate.roadcoordinate1
          $roadcoordinateB= $roadA.roadcoordinate.roadcoordinate2
          $roadcoordinateC=$roadB.roadcoordinate.roadcoordinate1
          $roadcoordinateD= $roadB.roadcoordinate.roadcoordinate2
          $v=$roadcoordinateA-$roadcoordinateB
          $u =$roadcoordinateC-$roadcoordinateD
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

           
$C1_C=$m1.X*($roadcoordinateC.X-$roadcoordinateA.X)+$m1.y*($roadcoordinateC.Y-$roadcoordinateA.Y)+$M1.Z*($roadcoordinateC.Z-$roadcoordinateA.Z)            
$C1_D=$m1.X*($roadcoordinateD.X-$roadcoordinateA.X)+$m1.y*($roadcoordinateD.Y-$roadcoordinateA.Y)+$M1.Z*($roadcoordinateD.Z-$roadcoordinateA.Z)            
$C2_A=$m2.x*($roadcoordinateA.x-$roadcoordinateC.x)+$m2.y*($roadcoordinateA.y-$roadcoordinateC.y)+$m2.z*($roadcoordinateA.z-$roadcoordinateC.z)
$C2_B=$m2.x*($roadcoordinateB.x-$roadcoordinateC.x)+$m2.y*($roadcoordinateB.y-$roadcoordinateC.y)+$m2.z*($roadcoordinateB.z-$roadcoordinateC.z)      
$C1_CD=$C1_C*$C1_D
$C2_AB=$C2_A*$C2_B
           <#
           根据 AX+BY+CZ+D=0
           
      
     
           



           
###  1：若C1(C) *C1(D)<0则CD异侧，否则C，D同侧#>    
if ($C1_CD -lt 0 -and $C2_AB -lt 0) {
<#AB，CD的最短距离为，AC向量（A可替换为AB上任意一点，C可替换为CD上任意一点）#>


$distance=[math]::abs( [System.Numerics.Vector3]::Dot(($roadcoordinateC-$roadcoordinateA),$n)/[math]::Sqrt([System.Numerics.Vector3]::Dot($n,$n)))


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
 
  $MinDis = ([road]::calcroute($roadcoordinateA,$roadB)),([ROAD]::calcroute($roadcoordinateB,$roadB))|Sort-Object -Property $_.weight
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

##  wynncraft_place class 
class wynncraft_place { 
   [System.Numerics.Vector3]$placecoordinate
   [int]$id
   [place_type]$type
   hidden $path = "$PSScriptRoot\xml\wynncraft_place.xml"

   
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

   [object]save(){

   $object=[XElement]::new("object",[XAttribute]::new("type","wynncraft_place"),
       [XElement]::new("property",[XAttribute]::new("name","placecoordinate"),
       [XElement]::new("property",[XAttribute]::new("name","x"),$this.placecoordinate.x),
       [XElement]::new("property",[XAttribute]::new("name","y"),$this.placecoordinate.y),
       [XElement]::new("property",[XAttribute]::new("name","z"),$this.placecoordinate.x)

       
       ),

       [XElement]::new("property",[XAttribute]::new("name","id"),$this.id),
       [XElement]::new("property",[XAttribute]::new("name","type"),$this.type)
       )




       return $object.tostring()


   }


   #### validate method for repeat adding
static [void]validate ([wynncraft_place]$wynncraft_place,[int]$distance_limit){

$wynncraft_places=Import-clixml $PSScriptRoot\xml\wynncraft_places.xml|Where-Object {$_.type -like $wynncraft_place.type}



$wynncraft_places|foreach-object {

   

$distance = [mainmath]::calc($wynncraft_place.placecoordinate,$_.placecoordinate)

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
   hidden $path = "$PSScriptRoot\xml\survival_place.xml"

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
   [Object]save(){

       $object = [XElement]::new("object",[XAttribute]::new("type","survival_place"),

       [XElement]::new("property",[XAttribute]::new("name","placecoordinate"),
       [XElement]::new("property",[XAttribute]::new("name","x"),$this.placecoordinate.x),
       [XElement]::new("property",[XAttribute]::new("name","y"),$this.placecoordinate.y),
       [XElement]::new("property",[XAttribute]::new("name","z"),$this.placecoordinate.z)

       
       
       ),
       [XElement]::new("property",[XAttribute]::new("name","dimension"),$this.dimension),
       [XElement]::new("property",[XAttribute]::new("name","type"),$this.type),
       [XElement]::new("property",[XAttribute]::new("name","id"),$this.id)
       )
       return $object.ToString()
   }

#### validation mathod for repeat adding
  static [void]validate ([survival_place]$survival_place,[int]$distance_limit){
       $survival_places = Import-clixml $PSScriptRoot\xml\survival_places.xml|Where-Object {$_.type -like $survival_place.type -and $_.dimension -like $survival_place.dimension}
   
     $survival_places|foreach-object {
      $distance= [mainmath]::calc($survival_place.placecoordinate,$_.placecoordinate)

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
   hidden $path = "$PSScriptRoot\xml\teleportation_place.xml"  
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
   elseif ($null -eq $value) {
       $this = $this.DoInit(0)
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

[Object]save(){


$object =[XElement]::new("object",[XAttribute]::new("type","teleportation_place"),
[XElement]::new("property",[XAttribute]::new("name","placecoordinate"),
[XElement]::new("property",[XAttribute]::new("name","x"),$this.placecoordinate.x),
[XElement]::new("property",[XAttribute]::new("name","y"),$this.placecoordinate.y),
[XElement]::new("property",[XAttribute]::new("name","z"),$this.placecoordinate.Z)
),
[XElement]::new("property",[XAttribute]::new("name","id"),$this.id ),
[XElement]::new("property",[XAttribute]::new("name","name"),$this.name)
)
return $object.ToString()   
}

  static [void] validate([teleportation_place]$teleportation_place,[int]$distance_limit) 
   
   {

       $teleportation_places=Import-clixml $PSScriptRoot\teleportation_places.xml|Where-Object($_.type -eq $teleportation_place.type)
       $distance_limit=50
 
       $teleportation_places| foreach-object {


           $distance=[mainmath]::calc($teleportation_place.placecoordinate,$_.placecoordinate)


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
   
       $distance = [mainmath]::calc($mycoordinate,$teleportation_place.placecoordinate)
       
   
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

#main GPS parameter holder class

      <#
.SYNOPSIS
search-place 
-wynncraft_place (placetype) -mycoordinate ()

-survival_place (dimension,type) -mycoordinate

-road (dimension) -mycoordinate ()
.DESCRIPTION
search the near place around you 

.PARAMETER Path
.
.PARAMETER LiteralPath
.
.EXAMPLE
 search-place -wynncraft_place "bank" -mycoordinate (1,2,3)
.NOTES
placetype :
    potion_merchant
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

    Dimension:
    nether
    the_end
    overworld

    Author: CN_CODEGOD
    Date: June 10, 2024


    #>

function search-place {




  
#search-place

    [CmdletBinding()]
    param (
   
        [Parameter(parametersetname="wynncraft_place")]
        [wynncraft_place]
        $wynncraft_place
        ,
        # Parameter help description
        [Parameter(parametersetname="survival_place")]
        [survival_place]
        $survival_place
        ,
        # 
        [Parameter(parametersetname="road")]
        [road]
        $road
        ,
      
        # Parameter help description
        [Parameter()]
        [placecoordinate]
        $mycoordinate
    )
   
 
   
   
      
    switch ($pscmdlet.parametersetname) {


  ##parmeterset for search-place -wynncraft_place
       wynncraft_place { $wynncraft_places= Import-xml $wynncraft_place.path|Where-Object { $_.type -like $wynncraft_place.type}
       
       

       $pair =$wynncraft_places|foreach-object {
        [wynncraft_place]::searchplace($mycoordinate,$_)
       }|sort-object -Property distance -Descending |select-object -Last 1


       "最近的{0}离这里{1},坐标为:{2},{3},{4}" -f $pair.type ,$pair.distance,$pair.x,$pair.y,$pair.z
    
    }
    ##parmeterset for search-place -road
       road {$roads= Import-xml $road.path|Where-Object {$_.dimension -like $road.dimension}
       

       $pair= $roads|foreach-object {

    [road]::searchplace($mycoordinate,$_.roadcoordinate)


       }|sort-object -Property distance -Descending |select-object -Last 1
       
       "最近的路离这里{0},坐标为{1},{2},{3}" -f $pair.distance,$pair.projectedpoint.x,$pair.projectedpoint.y,$pair.projectedpoint.z
}
##parmeterset for search-place -survival_place
   
       survival_place{$survival_places = Import-xml $survival_place.path|Where-Object {$_.dimension -like $survival_place.dimension -and $_.type -like $survival_place.type}

      $pair =  $survival_places|foreach-object {
                [survival_place]::searchplace($mycoordinate,$_)
       }|sort-object -property distance -Descending|select-object -Last 1 
       "最近的{0}离这里{1},坐标为{2},{3},{4}" -f $pair.type,$pair.distance,$pair.x,$pair.y,$pair.z
       }
       
       


   }
   

  
  
   
   
   
             


    
}
  #find-place
  
        <#
.SYNOPSIS
find-place 
 -wynncraft_place ()

 -survival_place ()

-road ()

-teleportation_place ()
.DESCRIPTION
get place from xml by id or type 

.PARAMETER Path
.
.PARAMETER LiteralPath
.
.EXAMPLE
get-place -wynncraft_place "blackSmith"


    Author: CN_CODEGOD
    Date: June 10, 2024

 
.NOTES


    #>
function get-place {
    

   [CmdletBinding()]
   param (
       [Parameter(parametersetname="survival_place")]
       [survival_place]
       $survival_place
       ,
       # parameter for wynncraft_place
       [Parameter(parametersetname="wynncraft_place")]
       [wynncraft_place]
       $wynncraft_place
       ,
       # parameter for road 
       [Parameter(parametersetname="road")]
       [road]
       $road
       ,
       # paramter for teleportation_place
       [Parameter(parametersetname="teleportation_place")]
       [teleportation_place]
       $teleportation_place

     
   )
   
   switch ($pscmdlet.parametersetname) {
    survival_place { 
Import-xml $survival_place.path|Where-Object { 
    $_.type -like $survival_place.type -or $_.id -eq $survival_place.id
}
     }
    wynncraft_place{ 
        Import-xml $wynncraft_place.path|Where-Object {
            $_.type -like $wynncraft_place.type -or $_.id -eq $wynncraft_place.id
        }
    }
    road { Import-xml  $road.path |Where-Object{
        $_.dimension -like $road.dimension -or $_.id -eq $road.id

    } }
    teleportation_place { 

        Import-xml $teleportation_place.path|Where-Object {$_.name -eq $teleportation_place.name -or $_.id -eq $teleportation_place.id}
    }  
    
   }



}
    
  
        <#
.SYNOPSIS
searach-place -teleportation_place [teleportation_place] -destination [vector3] -my coordinate [vector3]
 
search-place -road [road] -destination [vector3] -my coordinate [vector3]
 


.DESCRIPTION
search route from teleportation or road

.PARAMETER Path
.
.PARAMETER LiteralPath
.
.EXAMPLE
search-place -road ([pscustomobject]@{
dimension = 'nether' -mycoordinate (1,2,3) -destination (1,2,3)


search-place -teleportation_place -mycoordinate (1,2,3) -destination (1,2,3)
}

)


    Author: CN_CODEGOD
    Date: June 10, 2024

 
.NOTES


    #>
    function teleportation-route {
       [CmdletBinding()]    
       param (
           [Parameter()]
           [System.Numerics.Vector3]
           $destination
           ,
           # Parameter help description
           [Parameter()]
           [System.Numerics.Vector3]
           $mycoordinate
       )
        $teleportation_places= import-xml $PSScriptRoot'\xml\teleportation_place.xml'

        
$teleportation_places = import-xml $teleportation_place.Path

$pair = $teleportation_places|foreach-object {

    [teleportation_place]::calcroute($destination,$_)
 
} |sort-object -Property distance -Descending |select-object -Last 1  



"最佳的路线为:传送到{0}再前往目的地"  -f $pair.name

    }

function road-route {
   [CmdletBinding()]
   param (
       [Parameter()]
       [System.Numerics.Vector3]
       $destination
       ,
       # Parameter help description
       [Parameter()]
       [System.Numerics.Vector3]
       $mycoordinate
       ,
       # Parameter help description
       [Parameter()]
       [road]
       $road 

   )
    $roads = import-xml $road.path|Where-Object {$_.dimension -eq $road.dimension }
    


   
}

    
##function to road route







                
#add-place

        function add-place {
                <#
.SYNOPSIS
add-place
-wynncraft_place (placecoordinate,type)
-survival_place (placecoordinate,dimension,type)
-teleportation (placecoordinate,name)
-road (roadcoordinate,dimension,name)
.DESCRIPTION
    GPS function .add-place 
    add structure for GPS map
.PARAMETER Path
    The path to the 
.PARAMETER LiteralPath
.
.EXAMPLE
add-place -wynncraft_place "(1,2,3),bank"

.NOTES

place_type :
    potion_merchant
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

    dimension:
    nether
    the_end 
    overworld
    Author: CNCODEGOD
    Date: June 10, 2024
#>

           [CmdletBinding()]
           param (
               [Parameter(parametersetname="road")]
               [road]
               $road
               ,
               # 
               [Parameter(parametersetname="wynncraft_place")]
               [wynncraft_place]
               $wynncraft_place
               ,
              
              
                   [Parameter(parametersetname="survival_place")]
                [survival_place]
                   $survival_place
                   ,
                   
                   [Parameter(parametersetname="teleportation_place")]
                   [teleportation_place ]
                   $teleportation_place
               )
           
        
           switch ($pscmdlet.parametersetname) {
            #parameter for add-place -road
            road {

                
                  
                 
                    [road]::validate($road)
                    $id =[int]($roads|Sort-Object -Property id |Select-Object -Last 1).id+1
                  $road.id=$id
      save-object -object $road
                  "成功添加路线 ：{0},{1},{2}----{3},{4},{5}" -f $road.roadcoordinate.roadcoordinate1.x,$road.roadcoordinate.roadcoordinate1.y,$road.roadcoordinate.roadcoordinate1.z,$road.roadcoordinate.roadcoordinate2.x,$road.roadcoordinate.roadcoordinate2.y,$road.roadcoordinate.roadcoordinate2.z

                }
             
              #parameter for add-place -wynncraft_place
            wynncraft_place {
                switch ($wynncraft_place.type) {
                 
                chest { $distance_limit=5}
blackSmith  { $distance_li0mit=5}
potion_merchant  { $distance_limit=5}
tool_merchant  { $distance_limit=5}
identifier   { $distance_limit=5}

powder_master  { $distance_limit=5}


Default {$distance_limit=50}


                }
[wynncraft_place]::validate($wynncraft_place,$distance_limit)

$id =[int]($wynncraft_places  |Sort-Object -Property id |Select-Object -Last 1).id+1
$wynncraft_place.id =$id

save-object -object $wynncraft_place

"成功添加{0},坐标为:{1},{2},{3}" -f $wynncraft_place.type ,$wynncraft_place.placecoordinate.x,$wynncraft_place.placecoordinate.y,$wynncraft_place.placecoordinate.z

             }
#parameter for add-place -survival_place
            survival_place {
         

                switch ($survival_place.type) {
                    nether_portal {$distance_limit=5  }
                    Default  {$distance_limit=50  }
                    
                }
                [survival_place]::validate($survival_place,$distance_limit)
                

                $id =[int]($survival_places|Sort-Object -Property id |Select-Object -Last 1).id+1
                
            $survival_place.id  =$id    
            
                save-object -object $survival_place
            "成功添加生存存档{0}坐标：{1},{2},{3}" -f $survival_place.type,$survival_place.placecoordinate.x,$survival_place.placecoordinate.y,$survival_place.placecoordinate.z

            
                 }
                 #parameter for add-place -teleportation_place
            teleportation_place {

                [teleportation_place]::validate($teleportation_place,50)
            $id =[int]($teleportation_places|Sort-Object -Property id |Select-Object -Last 1).id+1
            $teleportation_place.id=$id 
            
                save-object -object $teleportation_place
            "成功添加传送点{0} ,坐标{1},{2},{3}" -f $teleportation_place.name,$teleportation_place.placecoordinate.x,$teleportation_place.placecoordinate.y,$teleportation_place.placecoordinate.z
           }

        }

    
    
}
function remove-place {
                    <#
.SYNOPSIS
remove-place
-wynncraft_place (id)
-survival_place (id)
-teleportation (id)
-road (id)
.DESCRIPTION
    GPS function remove-place
    remove structure in GPS map
.PARAMETER Path
    The path to the 
.PARAMETER LiteralPath
.
.EXAMPLE
remove-place -wynncraft_place "1"

.NOTES
    Author: CNCODEGOD
    Date: June 10, 2024
#>
    [CmdletBinding()]
    param (
        [Parameter(parametersetname="road")]
        [road]
        $road
        ,
        # 
        [Parameter(parametersetname="wynncraft_places")]
        [wynncraft_place]
        $wynncraft_place
        ,
     
            [Parameter(parametersetname="survival_places")]
             [survival_place]
            $survival_place
            ,
            
            [Parameter(parametersetname="teleportation_place")]
            [teleportation_place]
            $teleportation_place
        )
    
 
    
    switch ($pscmdlet.parametersetname) {
        ##parameterset script block for remove-place -road
        road { 


$roads = import-xml $road.path
$pair=$roads|Where-Object {$_.id -eq $road.id}
$roads=$roads|Where-Object {$_.id -ne $road.id}
$roads|export-object -path $road.path       
"成功移除{0}号路线:{1},{2},{3},{4},{5},{6}" -f $pair.id ,$pair.roadcoordinate.roadcoordinate1.x,$pair.roadcoordinate.roadcoordinate1.y,$pair.roadcoordinate.roadcoordinate1.z,$pair.roadcoordinate.roadcoordinate2.x1,$pair.roadcoordinate.roadcoordinate2.y,$pair.roadcoordinate.roadcoordinate2.z
        }
        ##parameterset script block for remove-place -wynncraft_place
        wynncraft_places {
$wynncraft_places= import-xml $wynncraft_place.path

$pair = $wynncraft_places|Where-Object {$_.id -eq $wynncraft_place.id}
$wynncraft_places= $wynncraft_places|Where-Object {$_.id -ne $wynncraft_place.id}
$wynncraft_places|export-object -Path $wynncraft_place.path
"成功移除{0}号:坐标为{1},{2},{3}" -f $pair.id ,$pair.placecoordinate.x,$pair.placecoordinate.y,$pair.placecoordinate.z



}
##parameterset script block for remove-place -survival_place
        survival_places { 
        $survival_places = import-xml $survival_place.path 

        $pair = $survival_places|Where-Object {$_.id -eq $road.id}
        $survival_places = $survival_places|Where-Object {$_.id -ne $survival_place.id}
        $survival_places|export-object -Path $survival_place.path
            "成功移除{0},坐标{1},{2},{3}" -f $pair.type,$pair.placecoordinate.x,$pair.placecoordinate.y,$pair.placecoordinate.z


        }
        ##parameterset script block for remove-place -teleportation_place
        teleportation_place { 
        $teleportation_places = import-xml $teleportation_place.path 
        $pair =  $teleportation_places|Where-Object {$_.id -eq $teleportation_place.id}
$teleportation_places = $teleportation_places|Where-Object {$_.id -ne $teleportation_place.id}
$teleportation_places|export-object -path $teleportation_place.path

"成功移除传送点{0}，坐标{1},{2},{3}" -f $pair.name,$pair.placecoordinate.x,$pair.placecoordinate.y,$pair.placecoordinate.z
    }
}

}



