# EDC Performance Tests Introduction

## Introduction
This document describes the design of the Eclipse Dataspace Connector (EDC) Performance Tests.
The EDC is the central communication component in Catena-X, which as a connector implements a framework agreement for sovereign, cross-organizational data exchange.

### Goals of the test
The test is intended to measures the performance in scenarios similar to reality of the automotive industry.
Due to the fact that the EDC maps many such scenarios and use cases, it was designed as a parameter-based, customizable test.
The test defines a framework that can be adapted to real business scenarios using defined parameters.
This is an attempt to cover a broad spectrum of use cases and their performance.

To ensure the credibility of the test, the test is based on defined characteristics:

- Real-world: The performance workload should have the characteristics of real-world systems.
- Complexity: The test should capture intra- and inter-company business processes from two counter parties.
- Openness and version independence: The test should be able to be implemented using different versions of the EDC and not be limited to a specific use case scenario.

## Application
The test and its framework are based on the Java-based test tool "Apache JMeter". The documentation and further information on this tool can be found at Link: https://jmeter.apache.org
The test scripts are implemented exclusively as .jmx files, an XML-coded script that uses JMeter as the default file format for testing.

In the first stage of these performance tests, the EDC is simulated using Minimum Tractus-X Dataspace (MXD). Further information on this can be found under the following link: https://eclipse-tractusx.github.io/docs-kits/kits/tractusx-edc/docs/kit/adoption-view/Adoption%20View/

# Test Design

## Definition of Terms
| Term                         | Explanation|
|------------------------------|------------------------------|
| OEM                          | An OEM or "Original Equipment Manufacturer" manufactures a part or component that is used in another company's product   |
| Supplier                     | An Supplier represents the end of the supply chain in the test scenario and manufactures the end product   |

## Test Setup
The relationship between the test setup and the setup of the Minimum Tractus-X Dataspace is visualized in the following figure. It should be emphasized that both the OEM and the supplier act as data recipients and senders. 
!["Visualization of the test setup"](/Test_SetUp.png)

## Functional structure of the test
The experiment is divided into three different phases. Each phase is implemented as own .jmx file.

### Setup
During the setup phase an initial set of asset, policy and contract data are loaded into the connectors. The purpose of these data sets is introduce a certain level of data aging before conducting measurements.   

### Measurement Interval
This phase represents the actual performance evaluation. The script runs through all standard processes that can be executed by the EDC. The process starts with the creation of assets, policies and contract definitions based on the number of mock-up data from the previous process. This is followed by further EDC processes such as "Create Catalogue" until the data transfer is negotiated and executed, as described in the EDC wiki: 
https://eclipse-tractusx.github.io/docs-kits/category/connector-kit/
In order to test this section as realistically as possible, the process is carried out for both OEMs ("OEM Plants") and suppliers ("Supplier Plants"). The section also contains the "Supplier Fleet Manager" process, a process designed to simulate employees at the supplier who request digital twins of the cars.

### Tear Down
During the tear-down phase, all previously created assets, policies and contracts are deleted from the connectors. 

# User Guide

## Installation of the required software
The minimum Tractus-X Dataspace is required to carry out the tests in a local environment. 
The software and tools required for this are described in the following wiki:
https://github.com/sap-contributions/eclipse-tractusx_tutorial-resources/blob/main/mxd/1_MXD_Introduction.md

The setup of the dataspace is explained further in the following wiki:
https://github.com/sap-contributions/eclipse-tractusx_tutorial-resources/blob/main/mxd/2_MXD_Setup.md

After installing the Tractus-X Dataspace, the test software must now be installed.
To do this, the Jmeter tool must first be installed. Download here:
https://jmeter.apache.org/download_jmeter.cgi
Add the JMETER_HOME environment variable and let it reference the /bin directory of JMeter.

To run the Jmeter tool, a Java Runtime Environment (JRE) is required, which can be installed here: 
https://www.java.com/de/download/manual.jsp

## Running the Evaluation
Once all tools and software have been installed and the Tractus-X Dataspace has been deployed as explained in the wiki, the test can be executed:

1. [OPTIONAL] Review and update the connectors properties in the file connector.properties. A brief explanation of all properties can be found in the User Guide of this document.
2. Execute the run_experiment.sh script.
3. As requested, define your local path where to save the test results.

# Open Tasks:
- Tear down currently deletes assets, policies, and contracts based on a counter.
- Documentation of properties in README