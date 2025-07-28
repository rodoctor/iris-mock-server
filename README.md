 [![Gitter](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/iris-mock-server)


[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat&logo=AdGuard)](LICENSE)
# Iris Mock Server

## Description
IRIS Mock Server simplifies API development by simulating REST and SOAP endpoints with zero-code configuration. Featuring a modern web interface and native Ensemble integration, it enables developers to quickly create and manage mocks, accelerating testing and eliminating external dependencies.

## Funcionalidades
- Support for REST and SOAP protocols
- Web interface for creating and editing mocks
- Customizable response configuration
- Ability to define content-type and status code
- Zero-code: fully configurable through the interface
- Runs via Docker with embedded InterSystems IRIS

## Getting Started

### Prerequisites
- [Git (Optional, for repository clone)](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) 
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)

### Clone the Repository
Clone or pull the repository into a local directory:

```bash
git clone git@github.com:rodoctor/iris-mock-server.git
```
Navigate to the directory and run:
```bash
cd iris-mock-server
```
Run docker compose
```bash
docker-compose up -d
```

Access the interface at: <br>
http://localhost:52773/app/index.html

### IPM
Open IRIS installation with IPM client installed:
```bash
IRISAPP>zpm "install iris-mock-server"
```

### Management portal
The management portal is available at: <br>
http://localhost:52773/csp/irisapp/EnsPortal.ProductionConfig.zen?$NAMESPACE=IRISAPP&

## Architecture Overview
```mermaid

graph TB
    %% External Systems
    Client[Client Application<br/>REST/SOAP Request]
    DevTeam[Development Team<br/>Web Interface]
    
    %% Web Interface Layer
    subgraph "Web Interface Layer"
        WebUI[Modern Web UI<br/>- Toast Notifications<br/>- Modal Search<br/>- Responsive Layout]
        Static[Static Assets<br/>- CSS Stylesheets<br/>- JavaScript Files<br/>- Images & Icons]
    end
    
    %% API Management Layer
    subgraph "API Management Layer"
        RestAPI[MockResponseController<br/>REST API Endpoints]
        
        subgraph "API Endpoints"
            GetAll[GET /getAllMockResponses]
            GetById[GET /getMockResponse/:id]
            Save[POST /saveMockResponse]
            Delete[DELETE /deleteMockResponse/:id]
        end
    end
    
    %% Business Logic Layer
    subgraph "Business Logic Layer"
        MockProcess[MockProcess<br/>Ensemble Business Process]
        MockOperation[Mock Operation<br/>Business Operation]
        
        subgraph "Message Classes"
            BPRequest[MockRequest<br/>Business Process Input]
            BPResponse[MockResponse<br/>Business Process Output]
            BORequest[ReturnMockMessageRequest<br/>Business Operation Input]
            BOResponse[ReturnMockMessageResponse<br/>Business Operation Output]
        end
    end
    
    %% Data Layer
    subgraph "Data Persistence Layer"
        Database[IRIS Database]
        MockTable[TblMockResponse<br/>- ID, Path, Action<br/>- Protocol, System<br/>- Response Content<br/>- Status Code<br/>- SOAP Action<br/>- Situation Active/Inactive]
    end
    
    %% Mock Service Flow
    subgraph "Mock Service Flow"
        MockService["Mock Service /mock/service/{system}/{path}"]
        Router[Protocol Router<br/>REST vs SOAP]
        ResponseGen[Response Generator<br/>Dynamic Content<br/>Status Codes<br/>Headers]
    end
    
    %% Connections - Web Interface Flow
    DevTeam --> WebUI
    WebUI --> RestAPI
    RestAPI --> GetAll
    RestAPI --> GetById
    RestAPI --> Save
    RestAPI --> Delete
    
    %% Connections - API to Data
    GetAll --> MockTable
    GetById --> MockTable
    Save --> MockTable
    Delete --> MockTable
    MockTable --> Database
    
    %% Connections - Mock Service Flow
    Client --> MockService
    MockService --> Router
    Router --> MockProcess
    MockProcess --> BPRequest
    BPRequest --> MockOperation
    MockOperation --> BORequest
    BORequest --> BOResponse
    BOResponse --> BPResponse
    BPResponse --> MockProcess
    MockProcess --> ResponseGen
    ResponseGen --> Client
    
    %% Data Flow for Mock Lookup
    MockOperation --> MockTable
    MockTable --> MockOperation
    
    %% Styling
    classDef webLayer fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    classDef apiLayer fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    classDef businessLayer fill:#e8f5e8,stroke:#1b5e20,stroke-width:2px
    classDef dataLayer fill:#fff3e0,stroke:#e65100,stroke-width:2px
    classDef mockLayer fill:#fce4ec,stroke:#880e4f,stroke-width:2px
    classDef external fill:#f5f5f5,stroke:#424242,stroke-width:2px
    
    class WebUI,Static webLayer
    class RestAPI,GetAll,GetById,Save,Delete apiLayer
    class MockProcess,MockOperation,BPRequest,BPResponse,BORequest,BOResponse businessLayer
    class Database,MockTable dataLayer
    class MockService,Router,ResponseGen mockLayer
    class Client,DevTeam external
```
## Using Example

## Project Structure
### Structure
```bash
.
└── src
    ├── IORedirect
    ├── activation
    ├── api
    │   └── rest
    ├── core
    │   ├── bo
    │   ├── bp
    │   ├── bs
    │   │   └── http
    │   ├── model
    │   │   └── http
    │   ├── msg
    │   │   ├── bo
    │   │   └── bp
    │   └── prd
    ├── csp
    │   └── irisapp
    │       └── assets
    └── data
        └── enum
```

## Contributing
Contributions are welcome and appreciated!
If you have suggestions for improvements, bug reports, or want to add new features, feel free to open an issue or submit a pull request.

Whether it’s code, documentation, ideas, or testing — your help is welcome. 

## Contributors
Rodolfo Moreira <br> <a href="https://www.linkedin.com/in/rodoctor/">![LinkedIn](https://img.shields.io/badge/linkedin-%230077B5.svg?style=for-the-badge&logo=linkedin&logoColor=white)</a>




# Teste

```mermaid
C4Context
    title System Context Diagram for IRIS Mock Server

    Person(dev, "Developer", "Creates and manages mock configurations via web interface")
    Person(tester, "Tester", "Uses mock APIs for testing applications")
    
    System(mockServer, "IRIS Mock Server", "Enterprise API simulation platform providing REST and SOAP mock services")
    
    System_Ext(clientApp, "Client Applications", "Applications consuming mock APIs for development and testing")
    System_Ext(realAPI, "Real APIs", "Actual production APIs being mocked")
    
    Rel(dev, mockServer, "Configures mocks", "HTTPS/Web UI")
    Rel(tester, mockServer, "Manages test scenarios", "HTTPS/Web UI")
    Rel(clientApp, mockServer, "Consumes mock APIs", "REST/SOAP")
    Rel(mockServer, realAPI, "Simulates behavior of", "Mock responses")

    UpdateRelStyle(dev, mockServer, $textColor="blue", $lineColor="blue")
    UpdateRelStyle(clientApp, mockServer, $textColor="green", $lineColor="green")
```

```mermaid
C4Container
    title Container Diagram for IRIS Mock Server

    Person(user, "User", "Developer/Tester using the system")
    
    Container(webUI, "Web Interface", "HTML/CSS/JS", "Modern responsive interface for mock management with glassmorphism design")
    Container(restAPI, "REST API", "MockResponseController", "Provides CRUD operations for mock configurations")
    Container(mockService, "Mock Service", "Ensemble BP/BO", "Processes incoming mock requests and returns configured responses")
    ContainerDb(database, "IRIS Database", "TblMockResponse", "Stores mock configurations and metadata")
    
    System_Ext(clients, "Client Applications", "Applications consuming mock APIs")
    
    Rel(user, webUI, "Manages mocks", "HTTPS")
    Rel(webUI, restAPI, "API calls", "JSON/REST")
    Rel(restAPI, database, "CRUD operations", "SQL")
    Rel(clients, mockService, "Mock requests", "REST/SOAP")
    Rel(mockService, database, "Lookup mock configs", "SQL")
    
    UpdateRelStyle(user, webUI, $textColor="blue", $lineColor="blue")
    UpdateRelStyle(clients, mockService, $textColor="green", $lineColor="green")
```

```mermaid
C4Component
    title Component Diagram for IRIS Mock Server

    Container(webUI, "Web Interface", "HTML/CSS/JS")
    Container(clients, "Client Applications", "External Apps")
    
    Component(controller, "MockResponseController", "REST Controller", "Handles CRUD operations for mock configurations")
    Component(process, "MockProcess", "Business Process", "Orchestrates mock request processing workflow")
    Component(operation, "MockOperation", "Business Operation", "Executes mock lookup and response generation")
    Component(mockTable, "TblMockResponse", "Persistent Class", "Mock configuration data model")
    
    ComponentDb(storage, "IRIS Storage", "Database", "Physical data storage layer")
    
    Rel(webUI, controller, "HTTP requests", "JSON")
    Rel(controller, mockTable, "Data access", "Object/SQL")
    Rel(clients, process, "Mock requests", "REST/SOAP")
    Rel(process, operation, "Internal messages", "Ensemble")
    Rel(operation, mockTable, "Query mocks", "SQL")
    Rel(mockTable, storage, "Persistence", "IRIS DB")
    
    UpdateRelStyle(webUI, controller, $textColor="blue", $lineColor="blue")
    UpdateRelStyle(clients, process, $textColor="green", $lineColor="green")
```

```mermaid
C4Deployment
    title Deployment Diagram for IRIS Mock Server

    Deployment_Node(devMachine, "Developer Machine", "Windows/Linux/Mac") {
        Container(browser, "Web Browser", "Chrome/Firefox/Safari", "Accesses mock management interface")
    }
    
    Deployment_Node(irisServer, "IRIS Server", "InterSystems IRIS") {
        Container(webServer, "Web Server", "CSP/Web Gateway", "Serves web interface and handles HTTP requests")
        Container(irisInstance, "IRIS Instance", "IRIS Database", "Runs Ensemble productions and stores data")
        
        Component(webFiles, "Static Files", "CSS/JS/HTML", "Web interface assets")
        Component(restEndpoints, "REST Endpoints", "MockResponseController", "API endpoints for mock management")
        Component(ensembleProduction, "Ensemble Production", "BP/BO Components", "Mock processing workflow")
        ComponentDb(dataStorage, "Data Tables", "TblMockResponse", "Mock configuration storage")
    }
    
    Deployment_Node(clientEnv, "Client Environment", "Various Platforms") {
        Container(testApps, "Test Applications", "Applications under test", "Consume mock APIs during development")
    }
    
    Rel(browser, webServer, "HTTPS", "443")
    Rel(webServer, irisInstance, "Internal", "IRIS Protocol")
    Rel(testApps, webServer, "HTTP/HTTPS", "Mock API calls")
    
    UpdateRelStyle(browser, webServer, $textColor="blue", $lineColor="blue")
    UpdateRelStyle(testApps, webServer, $textColor="green", $lineColor="green")
```