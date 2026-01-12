using namespace system.xml.linq

# Graph-related classes extracted from minecraft-GPS.PSM1 so they can be loaded independently.

class graph {
    $vertices
    $edges
    [bool]$isDirected

    graph() {
        $this.DoInit($false)
    }

    graph($isDirected) {
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
        $startVertex = $this.getVertexByKey($edge.startVertex.getKey())
        $endVertex = $this.getVertexByKey($edge.endVertex.getKey())

        if (!$startVertex) {
            $this.addVertex($edge.startVertex)
            $startVertex = $this.getVertexByKey($edge.startVertex.getKey())
        }

        if (!$endVertex) {
            $this.addVertex($edge.endVertex)
            $endVertex = $this.getVertexByKey($edge.endVertex.getKey())
        }

        if ($this.isDirected) {
            $startVertex.addEdge($edge)
        }
        else {
            $startVertex.addEdge($edge)
            $endVertex.addEdge($edge)
        }

        if ($this.edges[$edge.getKey()]) {
            throw 'Edge has already been added before'
        }
        else {
            $this.edges[$edge.getKey()] = $edge
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

    edge($startVertex, $endVertex) {
        $this.startVertex = $startVertex
        $this.endVertex = $endVertex
        $this.weight = $null
    }

    edge($startVertex, $endVertex, $weight) {
        $this.startVertex = $startVertex
        $this.endVertex = $endVertex
        $this.weight = $weight
    }

    [object] getKey() {
        $startVertexKey = $this.startVertex.getKey()
        $endVertexKey = $this.endVertex.getKey()
        return "$($startVertexkey)_$($endVertexkey)"
    }
}

class vertex {
    $value
    $edges

    vertex() {
        $this.DoInit($null)
    }

    vertex($value) {
        $this.DoInit($value)
    }

    hidden DoInit($value) {
        if ($value -eq $null) {
            throw 'Graph vertex must have a value'
        }

        $this.value = $value
        $this.edges = New-Object System.Collections.Generic.LinkedList[object]
    }

    [object] addEdge($edge) {
        $this.edges.add($edge)
        return $this
    }

    [object] getNeighbors() {
        $targetEdges = $this.edges.ForEach({ $_ })

        $neighborsConverter = {
            param($node)

            if ($node.startVertex.getKey() -eq $this.getKey()) {
                return $node.endVertex
            }

            return $node.startVertex
        }

        return @($targetEdges.ForEach{ &$neighborsConverter $_ })
    }

    [object] getKey() {
        return $this.value.id
    }

    [object] findEdge($vertex) {
        $edgeFinder = {
            param($edge)
            return $edge.startVertex -eq $vertex -Or $edge.endVertex -eq $vertex
        }

        $targetedges = $this.edges
        $currentNode = $targetedges.First

        while ($currentNode) {
            if (& $edgeFinder $currentNode.value) {
                if ($currentNode) {
                    return $currentNode.value
                }
                return $null
            }
            $currentNode = $currentNode.next
        }
        return $null
    }
}
