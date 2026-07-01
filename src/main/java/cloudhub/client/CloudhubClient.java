package cloudhub.client;

import java.util.concurrent.TimeUnit;

import okhttp3.OkHttpClient;

/**
 * Convenience entry point for the Cloudhub API client.
 *
 * <p>This class is <strong>hand-maintained</strong> (listed in
 * {@code .openapi-generator-ignore}) and is never overwritten by code generation.
 * It extends the generated {@link ApiClient} to add:
 * <ul>
 *   <li>a {@code (baseURL, apiKey)} constructor for one-line setup, and</li>
 *   <li>default 2-minute connect/read/write timeouts, since signing operations
 *       performed by the remote trust services can be slow.</li>
 * </ul>
 *
 * <p>A {@code CloudhubClient} can be passed anywhere an {@link ApiClient} is expected:
 * <pre>{@code
 * CloudhubClient client = new CloudhubClient("https://cloudhub.example.com", apiKey);
 * SessionsApi api = new SessionsApi(client);
 * }</pre>
 */
public class CloudhubClient extends ApiClient {

    private static final long DEFAULT_TIMEOUT_MINUTES = 2;

    /**
     * Creates a client with default timeouts. Set the base path and API key
     * (via {@link #setBasePath(String)} / {@link #setApiKey(String)}) before use.
     */
    public CloudhubClient() {
        super();
        applyDefaultTimeouts();
    }

    /**
     * Creates a ready-to-use client with default timeouts.
     *
     * @param baseURL the API base URL used in all HTTP requests
     * @param apiKey  the value sent in the {@code X-Api-Key} authentication header
     */
    public CloudhubClient(String baseURL, String apiKey) {
        super();
        applyDefaultTimeouts();
        setBasePath(baseURL);
        setApiKey(apiKey);
    }

    /**
     * Creates a client backed by a caller-supplied OkHttp client. The supplied
     * client's timeouts are left untouched.
     *
     * @param client a configured {@link okhttp3.OkHttpClient}
     */
    public CloudhubClient(OkHttpClient client) {
        super(client);
    }

    private void applyDefaultTimeouts() {
        setHttpClient(getHttpClient().newBuilder()
                .connectTimeout(DEFAULT_TIMEOUT_MINUTES, TimeUnit.MINUTES)
                .readTimeout(DEFAULT_TIMEOUT_MINUTES, TimeUnit.MINUTES)
                .writeTimeout(DEFAULT_TIMEOUT_MINUTES, TimeUnit.MINUTES)
                .build());
    }
}
