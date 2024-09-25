
describe 'GRAPH' {
    BeforeAll{
        
    }

Context 'generate graph' {
    it 'generate from graph.ps1'{
     $graph=    & "C:\Users\Administrator\new.graph.ps1" 
     $graph.edges.Values.startvertex|Should not be $null
     $graph.edges.Values.startvertex|%{$_.edges |Should not be $null }
    }
    it 'generate from templategraph.ps1' {
        $graph = & "C:\Program Files\PowerShell\7\Modules\minecraft-GPS\graph1.ps1"
        $graph.edges.Values.startvertex|Should not be $null
        $graph.edges.Values.startvertex|%{$_.edges |Should not be $null }
    }
}
}