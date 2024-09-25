


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



