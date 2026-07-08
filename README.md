# cloudhub-java-client

Cloudhub API client library for Java
- API version: 2.0.0

*Generated from the CloudHub OpenAPI spec by the [OpenAPI Generator](https://openapi-generator.tech). Hand-written customizations are kept in separate, protected files — see "Keeping this client up to date".*


## Keeping this client up to date

This client mirrors the [CloudHub](https://cloudhub.lacunasoftware.com/) REST API and is
**regenerated from its OpenAPI spec**. The sync is automated:

```shell
# capture the latest spec from CloudHub, regenerate, then build
pwsh scripts/Update-JavaClient.ps1
```

- `openapi/cloudhub.json` is the committed source of truth — `git diff` on it shows what changed upstream.
- Hand-written code (`cloudhub.client.CloudhubClient`, `cloudhub.CloudhubUtils`, `build.gradle`, this
  README) is protected by `.openapi-generator-ignore` and is never overwritten by generation.
- For a guided update (upstream-change summary, version bump, and the few judgment calls a generator
  can't make), use the **`update-cloudhub-client`** skill. See `CHANGELOG.md` for history.

Running the generator needs a **JDK 11+** (the produced library still targets Java 8) plus the **.NET
SDK** to build CloudHub. Generator config lives in `openapi-generator.gradle`.


## Requirements

Building the API client library requires:
1. Java 1.8+
2. Maven (3.8.3+)/Gradle (7.2+)

## Installation

To install the API client library to your local Maven repository, simply execute:

```shell
mvn clean install
```

To deploy it to a remote Maven repository instead, configure the settings of the repository and execute:

```shell
mvn clean deploy
```

Refer to the [OSSRH Guide](http://central.sonatype.org/pages/ossrh-guide.html) for more information.

### Maven users

Add this dependency to your project's POM:

```xml
<dependency>
  <groupId>com.lacunasoftware.cloudhub</groupId>
  <artifactId>cloudhub-client</artifactId>
  <version>2.0.0</version>
  <scope>compile</scope>
</dependency>
```

### Gradle users

Add this dependency to your project's build file:

```groovy
  repositories {
    mavenCentral()     // Needed if the 'cloudhub-client' jar has been published to maven central.
    mavenLocal()       // Needed if the 'cloudhub-client' jar has been published to the local maven repo.
  }

  dependencies {
     implementation "com.lacunasoftware.cloudhub:cloudhub-client:2.0.0"
  }
```

### Others

At first generate the JAR by executing:

```shell
mvn clean package
```

Then manually install the following JARs:

* `target/cloudhub-client-2.0.0.jar`
* `target/lib/*.jar`

## Getting Started

Please follow the [installation](#installation) instruction and execute the following Java code:

```java

// Import classes:
import cloudhub.client.ApiClient;
import cloudhub.client.ApiException;
import cloudhub.client.Configuration;
import cloudhub.client.auth.*;
import cloudhub.client.models.*;
import cloudhub.SessionsApi;

public class Example {
  public static void main(String[] args) {
    //Add endpoint and API Key
    String endpoint = "http://localhost"
    String apiKey = "YOUR_API_KEY"
    // Create client instance
    CloudhubClient cloudhubClient = new CloudhubClient(endpoint, apiKey);
    
    SessionsApi apiInstance = new SessionsApi(cloudhubClient);
    String session = "session_example"; // String | 
    try {
      byte[] result = apiInstance.apiSessionsCertificateGet(session);
      System.out.println(result);
    } catch (ApiException e) {
      System.err.println("Exception when calling SessionsApi#apiSessionsCertificateGet");
      System.err.println("Status code: " + e.getCode());
      System.err.println("Reason: " + e.getResponseBody());
      System.err.println("Response headers: " + e.getResponseHeaders());
      e.printStackTrace();
    }
  }
}

```

## Documentation for API Endpoints

All URIs are relative to *http://localhost*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*SessionsApi* | [**apiSessionsCertificateGet**](docs/SessionsApi.md#apiSessionsCertificateGet) | **GET** /api/sessions/certificate | 
*SessionsApi* | [**apiSessionsPost**](docs/SessionsApi.md#apiSessionsPost) | **POST** /api/sessions | 
*SessionsApi* | [**apiSessionsServicesGet**](docs/SessionsApi.md#apiSessionsServicesGet) | **GET** /api/sessions/services | 
*SessionsApi* | [**apiSessionsServicesNamePost**](docs/SessionsApi.md#apiSessionsServicesNamePost) | **POST** /api/sessions/services/{name} | 
*SessionsApi* | [**apiSessionsSignHashPost**](docs/SessionsApi.md#apiSessionsSignHashPost) | **POST** /api/sessions/sign-hash | 
*SessionsApi* | [**apiV2SessionsCertificateGet**](docs/SessionsApi.md#apiV2SessionsCertificateGet) | **GET** /api/v2/sessions/certificate | 


## Documentation for Models

 - [CertificateModel](docs/CertificateModel.md)
 - [IdentifierTypes](docs/IdentifierTypes.md)
 - [ServiceSessionCreateRequest](docs/ServiceSessionCreateRequest.md)
 - [ServiceSessionCreateResponse](docs/ServiceSessionCreateResponse.md)
 - [SessionCreateRequest](docs/SessionCreateRequest.md)
 - [SessionModel](docs/SessionModel.md)
 - [SignHashRequest](docs/SignHashRequest.md)
 - [TrustServiceAuthParametersModel](docs/TrustServiceAuthParametersModel.md)
 - [TrustServiceInfoModel](docs/TrustServiceInfoModel.md)
 - [TrustServiceSessionTypes](docs/TrustServiceSessionTypes.md)


## Documentation for Authorization

Authentication schemes defined for the API:
### ApiKey

- **Type**: API key
- **API key parameter name**: X-Api-Key
- **Location**: HTTP header


## Recommendation

It's recommended to create an instance of `CloudhubClient` per thread in a multithreaded environment to avoid any potential issues.

## Author



