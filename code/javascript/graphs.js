'use strict';
//Graphs
class Vertex {
  constructor(value) {
    this.value = value;
    this.inEdges = [];
    this.outEdges = [];
    this.visited = false;
  }

  visit() {
    this.visited = true;
  }

  deleteOutEdge(outEdge) {
    for (let i = 0; i < this.outEdges.length; i++) {
      if (this.outEdges[i] === outEdge) {
        this.outEdges.splice(i, 1);
        break;
      }
    }
  }

  deleteInEdge(inEdge) {
    for (let i = 0; i < this.inEdges.length; i++) {
      if (this.inEdges[i] === inEdge) {
        this.inEdges.splice(i, 1);
        break;
      }
    }
  }
}

class Edge {
  constructor(fromVertex, toVertex, cost) {
    this.fromVertex = fromVertex;
    this.toVertex = toVertex;
    this.cost = cost || 1;
    fromVertex.outEdges.push(this);
    toVertex.inEdges.push(this);
  }

  destroy() {
    this.toVertex.deleteInEdge(this);
    this.fromVertex.deleteOutEdge(this);
    this.toVertex = undefined;
    this.fromVertex = undefined;
  }
}

function breadthFirstSearch(vertex, target) {
  let queue = [vertex];
  while (queue.length > 0) {
    let probeVertex = queue.shift();
    probeVertex.visit();
    if (probeVertex.value === target) {
      return probeVertex;
    } else {
      probeVertex.outEdges.forEach((outEdge) => {
        let neighborVertex = outEdge.toVertex;
        if (!neighborVertex.visit()) {
          queue.push(neighborVertex);
        }
      });
    }
  }
  return null;
}

function depthFirstSearch(vertex, target) {
  if (vertex.value === target) {
    return vertex;
  } else {
    for (let i = 0; i < vertex.outEdges.length; i++) {
      let neighborVertex = vertex.outEdges[i].toVertex;
      let searchResult = depthFirstSearch(neighborVertex, target);
      if (searchResult) {
        return searchResult;
      }
    }
  }
  return null;
}

const nodeA = new Vertex(1);
const nodeB = new Vertex(2);
const nodeC = new Vertex(3);
const nodeD = new Vertex(4);
const AtoB = new Edge(nodeA, nodeB);
const AtoC = new Edge(nodeA, nodeC);
const AtoD = new Edge(nodeA, nodeD);
