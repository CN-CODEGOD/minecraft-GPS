. $PSScriptRoot\graph.class.ps1
. $PSScriptRoot\graph1.ps1
. $PSScriptRoot\gps.class.ps1
. $PSScriptRoot\bellman-ford




#main GPS parameter holder class


function search-place {




        <#
.SYNOPSIS
search-place 
-wynncraft_place (placetype) -mycoordinate ()

-survival_place (dimension,type) -mycoordinate

-road (dimension) -mycoordinate ()
.DESCRIPTION
GPS module function search-place 
search the structure near around you
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
       wynncraft_place { $wynncraft_places= Import-clixml $PSScriptRoot\xml\wynncraft_places.xml|Where-Object { $_.type -like $wynncraft_place.type}
       
       

       $pair =$wynncraft_places|foreach-object {
        [wynncraft_place]::searchplace($mycoordinate,$_)
       }|sort-object -Property distance -Descending |select-object -Last 1


       "最近的{0}离这里{1},坐标为:{2},{3},{4}" -f $pair.type ,$pair.distance,$pair.x,$pair.y,$pair.z
    
    }
    ##parmeterset for search-place -road
       road {$roads= Import-clixml $PSScriptRoot\xml\roads.xml|Where-Object {$_.dimension -like $road.dimension}
       

       $pair= $roads|foreach-object {

    [road]::searchplace($mycoordinate,$_.roadcoordinate)


       }|sort-object -Property distance -Descending |select-object -Last 1
       
       "最近的路离这里{0},坐标为{1},{2},{3}" -f $pair.distance,$pair.projectedpoint.x,$pair.projectedpoint.y,$pair.projectedpoint.z
}
##parmeterset for search-place -survival_place
   
       survival_place{$survival_places = Import-clixml $PSScriptRoot\xml\survival_places.xml|Where-Object {$_.dimension -like $survival_place.dimension -and $_.type -like $survival_place.type}

      $pair =  $survival_places|foreach-object {
                [survival_place]::searchplace($mycoordinate,$_)
       }|sort-object -property distance -Descending|select-object -Last 1 
       "最近的{0}离这里{1},坐标为{2},{3},{4}" -f $pair.type,$pair.distance,$pair.x,$pair.y,$pair.z
       }
       
       


   }
   

  
  
   
   
   
             


    
}
  #find-place
function find-place {
    
        <#
.SYNOPSIS
find-place 
 -wynncraft_place ()

 -survival_place ()

-road ()

-teleportation_place ()
.DESCRIPTION
GPS module function search-place 
search the structure near around you
.PARAMETER Path
.
.PARAMETER LiteralPath
.
.EXAMPLE
find-place -wynncraft_place "bank"
____________________
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
_________________________________
    Dimension:
    nether
    the_end
    overworld

    Author: CN_CODEGOD
    Date: June 10, 2024

 
.NOTES


    #>

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
Import-clixml $PSScriptRoot\xml\survival_places.xml|Where-Object { 
    $_.type -like $survival_place.type -or $_.id -eq $survival_place.id
}
     }
    wynncraft_place{ 
        Import-clixml $PSScriptRoot\xml\wynncraft_places.xml|Where-Object {
            $_.type -like $wynncraft_place.type -or $_.id -eq $wynncraft_place.id
        }
    }
    road { Import-clixml $PSScriptRoot\xml\roads.xml |Where-Object{
        $_.dimension -like $road.dimension -or $_.id -eq $road.id

    } }
    teleportation_place { 

        Import-clixml $PSScriptRoot\xml\teleportation_places.xml|Where-Object {$_.name -eq $teleportation_place.name -or $_.id -eq $teleportation_place.id}
    }  
    
   }



}
    
          ##function to teleportation route
function teleportation-route {
 [CmdletBinding()]
 param (
     [Parameter()]
     [placecoordinate]
     $destination
 )

 $teleportation_places= Import-clixml $PSScriptRoot\xml\teleportation_places.xml
    
    $pair = $teleportation_places|foreach-object {

                [teleportation_place]::calcroute($destination,$_)
             
            } |sort-object -Property distance -Descending |select-object -Last 1  
       
       
        
           "最佳的路线为:传送到{0}再前往目的地"  -f $pair.name
    
     
        }
    
##function to road route

function road-route {
 [CmdletBinding()]
 param (
     [Parameter()]
     [road]
     $road
     ,
     
     [Parameter()]
     [placecoordinate]
     $destination
     ,
     
     [Parameter()]
     [placecoordinate]
     $mycoordinate
 )

 
 
$myplace = [place]::new($mycoordinate)
$destinationwtk = [place]::new($destination,"P")
 $graph= graph $myplace $destinationwtk  $road.dimension
 $PATHS  = bellman-ford $graph 
$distances=$paths[0]
$distance  =$distances["p"].weight
$previousVertices=$paths[1]
#FIND full paths 
"最佳路线:"


    
$currentvertex= $graph.getVertexByKey("p")
$previousvertex =$previousVertices["p"]


"{0},{1},{2}---{3},{4},{5}" -f $currentroute.startVertex.x,$currentroute.startVertex.y,$currentroute.startVertex.z,$currentroute.endvertex.x,$currentroute.endVertex.y,$currentroute.endVertex.z





 
"全长为{0}" -f $distance
}






                
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

                
                  
                    $roads = Import-clixml $PSScriptRoot\xml\roads.xml
                    [road]::validate($road)
                    $id =[int]($roads|Sort-Object -Property id |Select-Object -Last 1).id+1
                  $road.id=$id
                  $roads=[System.Collections.Generic.List[road]]$road+$roads
                  $roads|export-Clixml $PSScriptRoot\xml\roads.xml
                  "成功添加路线 ：{0},{1},{2}----{3},{4},{5}" -f $road.roadcoordinate.x,$road.roadcoordinate.y,$road.roadcoordinate.z,$road.roadcoordinate.x1,$road.roadcoordinate.y1,$road.roadcoordinate.z1

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
$wynncraft_places = Import-clixml $PSScriptRoot\xml\wynncraft_places.xml
$id =[int]($wynncraft_places  |Sort-Object -Property id |Select-Object -Last 1).id+1
$wynncraft_place.id =$id
$wynncraft_places=[System.Collections.Generic.List[wynncraft_place]]$wynncraft_place+$wynncraft_places
$wynncraft_places|Export-Clixml $PSScriptRoot\xml\wynncraft_places.xml

"成功添加{0},坐标为:{1},{2},{3}" -f $wynncraft_place.type ,$wynncraft_place.placecoordinate.x,$wynncraft_place.placecoordinate.y,$wynncraft_place.placecoordinate.z

             }
#parameter for add-place -survival_place
            survival_place {
         

                switch ($survival_place.type) {
                    nether_portal {$distance_limit=5  }
                    Default  {$distance_limit=50  }
                    
                }
                [survival_place]::validate($survival_place,$distance_limit)
                $survival_places = Import-clixml $PSScriptRoot\xml\survival_places.xml

                $id =[int]($survival_places|Sort-Object -Property id |Select-Object -Last 1).id+1
                
            $survival_place.id=$id    
            
            $survival_places=[System.Collections.Generic.List[survival_place]]$survival_place+$survival_places
            $survival_places|Export-Clixml $PSScriptRoot\xml\survival_places.xml
            "成功添加生存存档{0}坐标：{1},{2},{3}" -f $survival_place.type,$survival_place.placecoordinate.x,$survival_place.placecoordinate.y,$survival_place.placecoordinate.z

            
                 }
                 #parameter for add-place -teleportation_place
            teleportation_place {$teleportation_places = Import-clixml $PSScriptRoot\xml\teleportation_places.xml
                [teleportation_place]::validate($teleportation_place,50)
            $id =[int]($teleportation_places|Sort-Object -Property id |Select-Object -Last 1).id+1
            $teleportation_place.id=$id 
            
            $teleportation_places=[System.Collections.Generic.List[teleportation_place]]$teleportation_place + $teleportation_places
            $teleportation_places|Export-Clixml $PSScriptRoot\xml\teleportation_places.xml
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


$roads = Import-clixml $PSScriptRoot\xml\roads.xml
$pair=$roads|Where-Object {$_.id -eq $road.id}
$roads=$roads|Where-Object {$_.id -ne $road.id}
$roads|Export-Clixml -path $PSScriptRoot\xml\roads.xml        
"成功移除{0}号路线:{1},{2},{3},{4},{5},{6}" -f $pair.id ,$pair.roadcoordinate.x,$pair.roadcoordinate.y,$pair.roadcoordinate.z,$pair.roadcoordinate.x1,$pair.roadcoordinate.y1,$pair.roadcoordinate.z1
        }
        ##parameterset script block for remove-place -wynncraft_place
        wynncraft_places {
            $wynncraft_places = Import-clixml $PSScriptRoot\xml\wynncraft_places.xml
            $pair=   $wynncraft_places|Where-Object {$_.id -eq $wynncraft_place.id}
            $wynncraft_places = $wynncraft_places|Where-Object {$_.id -ne $wynncraft_place.id}

            $wynncraft_places|Export-Clixml -path $PSScriptRoot\xml\wynncraft_places.xml   
            " 成功移除{0},坐标{1},{2},{3}" -f $pair.type,$pair.placecoordinate.x,$pair.placecoordinate.y,$pair.placecoordinate.z

}
##parameterset script block for remove-place -survival_place
        survival_places { 
            $survival_places = Import-clixml $PSScriptRoot\xml\survival_places.xml
            $pair=   $survival_places|Where-Object {$_.id -eq $survival_place.id}
            $survival_places = $survival_places|Where-Object {$_.id -ne $survival_place.id}
            $survival_places|Export-Clixml -path $PSScriptRoot\xml\survival_places.xml
            "成功移除{0},坐标{1},{2},{3}" -f $pair.type,$pair.placecoordinate.x,$pair.placecoordinate.y,$pair.placecoordinate.z


        }
        ##parameterset script block for remove-place -teleportation_place
        teleportation_place { 
        $teleportation_places = Import-clixml $PSScriptRoot\xml\teleportation_places.xml
        $pair =  $teleportation_places|Where-Object {$_.id -eq $teleportation_place.id}
$teleportation_places = $teleportation_places|Where-Object {$_.id -ne $teleportation_place.id}
$teleportation_places|Export-Clixml -path $PSScriptRoot\xml\teleportation.xml

"成功移除传送点{0}，坐标{1},{2},{3}" -f $pair.name,$pair.placecoordinate.x,$pair.placecoordinate.y,$pair.placecoordinate.z
    }
}

}



