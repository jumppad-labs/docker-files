Feature: Nomad Cluster
  In order to test Nomad clusters
  I should apply a blueprint
  And test the output
  
  @Single
  Scenario Outline: Nomad Cluster
    Given I have a running blueprint
    Then the following resources should be running
      | name                                    |
      | resource.network.cloud                  |
      | resource.nomad_cluster.dev                |
    And a HTTP call to "http://localhost:19090" should result in status 200

  @All
  Scenario Outline: Nomad Cluster
    Given the jumppad variable "version" has a value "<version>"
    And I have a running blueprint
    Then the following resources should be running
      | name                                    |
      | resource.network.cloud                  |
      | resource.nomad_cluster.dev                |
    And a HTTP call to "http://localhost:19090" should result in status 200
  
  Examples: 
    | version          |
    | v1.8.0           |
    | v1.8.1           |
    | v1.8.2           |
    | v1.8.3           |
    | v1.8.4           |
