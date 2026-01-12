. "$PSScriptRoot/graph.class.ps1"
. "$PSScriptRoot/gps.class.ps1"

$road = [road]([pscustomobject]@{
    name = "Spawn-To-Village"
    dimension = [dimension]::overworld
    id = 1
    roadcoordinate = [pscustomobject]@{
        roadcoordinate1 = [pscustomobject]@{
            x = 0
            y = 64
            z = 0
        }
        roadcoordinate2 = [pscustomobject]@{
            x = 120
            y = 64
            z = 80
        }
    }
})

$road
