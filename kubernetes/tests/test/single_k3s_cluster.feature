Feature: Kubernetes Cluster
  In order to test Kubernetes clusters
  I should apply a blueprint
  And test the output
  
  @Single 
  Scenario Outline: K3s Cluster
    Given I have a running blueprint
    Then the following resources should be running
      | name                                    |
      | resource.network.cloud                  |
      | resource.k8s_cluster.k3s                |
    And a HTTP call to "http://localhost:18200" should result in status 200

  @All
  Scenario Outline: K3s Cluster
    Given the jumppad variable "version" has a value "<version>"
    And I have a running blueprint
    Then the following resources should be running
      | name                                    |
      | resource.network.cloud                  |
      | resource.k8s_cluster.k3s                |
    And a HTTP call to "http://localhost:18200" should result in status 200
  
  Examples: 
    | version           |
    | v1.27.8           |
    | v1.29.0           |
    | v1.29.1           |
    | v1.31.0           |
    | v1.31.1           |
