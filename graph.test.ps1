. "C:\Program Files\TEST\graph.ps1"
. C:\Users\34683\BFS\bellman-ford.ps1
. C:\Users\34683\BFS\graph.class.ps1
. C:\Users\34683\BFS\gps.class.ps1
describe 'GRAPH' {

    context 'Queue' {

        it 'test queue'{

            $roadsque= New-Object System.Collections.Generic.Queue[object]
            $roadsque.Enqueue(1)
            $roadsque.Enqueue(2)
            $roadsque.Enqueue(3)
            $roadsque.Count|Should BE 3
                $roadsque.ForEach(
                {$_+1}
                )|Should BE 2,3,4
        }
    }
    context 'graph function'{
it 'test graph edge'{
    $mycoordinate =[placecoordinate](1,2,3)
    $destination =[placecoordinate](100,100,100)
    
    $graph = graph $mycoordinate $destination "THE_END"
    $graph | should not be $null

}

    }
}