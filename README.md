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