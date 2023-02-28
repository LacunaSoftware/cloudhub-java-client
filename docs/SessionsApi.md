# SessionsApi

All URIs are relative to *http://localhost*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**apiSessionsCertificateGet**](SessionsApi.md#apiSessionsCertificateGet) | **GET** /api/sessions/certificate |  |
| [**apiSessionsPost**](SessionsApi.md#apiSessionsPost) | **POST** /api/sessions |  |
| [**apiSessionsSignHashPost**](SessionsApi.md#apiSessionsSignHashPost) | **POST** /api/sessions/sign-hash |  |


<a name="apiSessionsCertificateGet"></a>
# **apiSessionsCertificateGet**
> byte[] apiSessionsCertificateGet(session)



### Example
```java
// Import classes:
import cloudhub.client.CloudhubClient;
import cloudhub.client.ApiException;
import cloudhub.client.Configuration;
import cloudhub.client.auth.*;
import cloudhub.client.models.*;
import cloudhub.SessionsApi;

public class Example {
  public static void main(String[] args) {
    CloudhubClient defaultClient = Configuration.getDefaultCloudhubClient();
    defaultClient.setBasePath("http://localhost");
    
    // Configure API key authorization: ApiKey
    ApiKeyAuth ApiKey = (ApiKeyAuth) defaultClient.getAuthentication("ApiKey");
    ApiKey.setApiKey("YOUR API KEY");
    // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
    //ApiKey.setApiKeyPrefix("Token");

    SessionsApi apiInstance = new SessionsApi(defaultClient);
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

### Parameters

| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **session** | **String**|  | [optional] |

### Return type

**byte[]**

### Authorization

[ApiKey](../README.md#ApiKey)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Success |  -  |

<a name="apiSessionsPost"></a>
# **apiSessionsPost**
> SessionModel apiSessionsPost(sessionCreateRequest)



### Example
```java
// Import classes:
import cloudhub.client.CloudhubClient;
import cloudhub.client.ApiException;
import cloudhub.client.Configuration;
import cloudhub.client.auth.*;
import cloudhub.client.models.*;
import cloudhub.SessionsApi;

public class Example {
  public static void main(String[] args) {
    CloudhubClient defaultClient = Configuration.getDefaultCloudhubClient();
    defaultClient.setBasePath("http://localhost");
    
    // Configure API key authorization: ApiKey
    ApiKeyAuth ApiKey = (ApiKeyAuth) defaultClient.getAuthentication("ApiKey");
    ApiKey.setApiKey("YOUR API KEY");
    // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
    //ApiKey.setApiKeyPrefix("Token");

    SessionsApi apiInstance = new SessionsApi(defaultClient);
    SessionCreateRequest sessionCreateRequest = new SessionCreateRequest(); // SessionCreateRequest | 
    try {
      SessionModel result = apiInstance.apiSessionsPost(sessionCreateRequest);
      System.out.println(result);
    } catch (ApiException e) {
      System.err.println("Exception when calling SessionsApi#apiSessionsPost");
      System.err.println("Status code: " + e.getCode());
      System.err.println("Reason: " + e.getResponseBody());
      System.err.println("Response headers: " + e.getResponseHeaders());
      e.printStackTrace();
    }
  }
}
```

### Parameters

| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **sessionCreateRequest** | [**SessionCreateRequest**](SessionCreateRequest.md)|  | [optional] |

### Return type

[**SessionModel**](SessionModel.md)

### Authorization

[ApiKey](../README.md#ApiKey)

### HTTP request headers

 - **Content-Type**: application/json-patch+json, application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Success |  -  |

<a name="apiSessionsSignHashPost"></a>
# **apiSessionsSignHashPost**
> byte[] apiSessionsSignHashPost(signHashRequest)



### Example
```java
// Import classes:
import cloudhub.client.CloudhubClient;
import cloudhub.client.ApiException;
import cloudhub.client.Configuration;
import cloudhub.client.auth.*;
import cloudhub.client.models.*;
import cloudhub.SessionsApi;

public class Example {
  public static void main(String[] args) {
    CloudhubClient defaultClient = Configuration.getDefaultCloudhubClient();
    defaultClient.setBasePath("http://localhost");
    
    // Configure API key authorization: ApiKey
    ApiKeyAuth ApiKey = (ApiKeyAuth) defaultClient.getAuthentication("ApiKey");
    ApiKey.setApiKey("YOUR API KEY");
    // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
    //ApiKey.setApiKeyPrefix("Token");

    SessionsApi apiInstance = new SessionsApi(defaultClient);
    SignHashRequest signHashRequest = new SignHashRequest(); // SignHashRequest | 
    try {
      byte[] result = apiInstance.apiSessionsSignHashPost(signHashRequest);
      System.out.println(result);
    } catch (ApiException e) {
      System.err.println("Exception when calling SessionsApi#apiSessionsSignHashPost");
      System.err.println("Status code: " + e.getCode());
      System.err.println("Reason: " + e.getResponseBody());
      System.err.println("Response headers: " + e.getResponseHeaders());
      e.printStackTrace();
    }
  }
}
```

### Parameters

| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **signHashRequest** | [**SignHashRequest**](SignHashRequest.md)|  | [optional] |

### Return type

**byte[]**

### Authorization

[ApiKey](../README.md#ApiKey)

### HTTP request headers

 - **Content-Type**: application/json-patch+json, application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Success |  -  |

