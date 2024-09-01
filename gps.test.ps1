import-module "C:\Users\34683\BFS\minecraft-GPS.PSM1"
describe 'test GPS module'
context 'find-place' {

    it 'find wynncraft place'{
    find-place -wynncraft_place ([wynncraft_place]::new("black_smith"))
    }

}
context 'add-place' {

add-place -wynncraft_place ((1,2,3),"blacksmith")

}
context 'remove-place'{
remove-place -wynncraft_place 1


}
context 'road-route' {

road-route -mycoordinate (1,2,3) -destination (1,2,3) -road "the_end"
}

context 'teleportation-route'{
teleportation-route -mycoordinate (1,2,3)

}
