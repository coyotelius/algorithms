//
//  AdjacencyList.swift
//  Algorithms
//
//  Created by Rahul Ranjan on 3/29/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import Foundation

class AdjancencyListGraph<T: Hashable> {
  var adjacencyDict: [Vertex<T>: [Edge<T>]]

  init() {
    self.adjacencyDict = [:]
  }
}

extension AdjancencyListGraph: Graphable {
  @discardableResult
  public func createVertex(data: T) -> Vertex<T> {
    let vertex = Vertex(data: data)
    adjacencyDict.updateValue([], forKey: vertex)
    return vertex
  }

  func addDirectedEdge(from source: Vertex<T>,
                       to destination: Vertex<T>,
                       weight: Double?) {
    let edge = Edge(source: source,
                    destination: destination,
                    weight: weight)
    adjacencyDict[source]?.append(edge)
  }
    
  func addUnDirectedEdge(vertices: (Vertex<T>, Vertex<T>),
                         weight: Double?) {
    let (src, dest) = vertices
    addDirectedEdge(from: src, to: dest, weight: weight)
    addDirectedEdge(from: dest, to: src, weight: weight)
  }
    
  func add(_ type: EdgeType,
           from source: Vertex<T>,
           to destination: Vertex<T>, weight: Double?) {
      switch type {
      case .directed:
        addDirectedEdge(from: source, to: destination, weight: weight)
      case .undirected:
        addUnDirectedEdge(vertices: (source, destination), weight: weight)
      }
    }
    
  func weight(fom source: Vertex<T>,
              to destination: Vertex<T>) -> Double? {
    guard let edges = adjacencyDict[source] else {
      return nil
    }

    for edge in edges {
      if edge.destination == destination {
        return edge.weight
      }
    }

    return nil
  }
    
  func edges(from source: Vertex<T>) -> [Edge<T>]? {
    return adjacencyDict[source]
  }
  
  func neighbours(for node: Vertex<T>) -> [Vertex<T>]? {
    if let e = edges(from: node) {
      return e.map { $0.destination }
    }
    return nil
  }

  public var description: CustomStringConvertible {
    var result = ""
    for (vertex, edges) in adjacencyDict {
      var edgeString = ""
      for (_, edge) in edges.enumerated() {
          edgeString.append("\(edge.destination) ")
      }
      result.append("\(vertex) --> { \(edgeString)} \n")
    }
    return result
  }
}

func initialiseAdjacencyListGraph() -> (AdjancencyListGraph<String>, Vertex<String>) {
  let graph = AdjancencyListGraph<String>()

  let a = graph.createVertex(data: "a")
  let b = graph.createVertex(data: "b")
  let c = graph.createVertex(data: "c")
  let d = graph.createVertex(data: "d")

  //  a ---> b ----> c <-
  //  | <--- ^         \_|
  //  v      |
  //  d -----
  graph.add(.undirected, from: a, to: b, weight: 5)
  graph.add(.directed, from: b, to: c, weight: 6)
  graph.add(.directed, from: c, to: c, weight: 3)
  graph.add(.directed, from: a, to: d, weight: 3)
  graph.add(.directed, from: d, to: b, weight: 3)

  print(graph.description)

  return (graph, b)
}
