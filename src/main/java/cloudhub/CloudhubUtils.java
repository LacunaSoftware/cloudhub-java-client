package cloudhub;

import java.util.Base64;

/**
 * Lacuna-specific helper utilities for working with the Cloudhub API.
 *
 * <p>This class is <strong>hand-maintained</strong> (listed in
 * {@code .openapi-generator-ignore}) and is never overwritten by code generation.
 * These helpers previously lived inside the generated {@code SessionsApi}; they were
 * moved here so they survive regeneration.
 */
public final class CloudhubUtils {

    private CloudhubUtils() {
    }

    /**
     * Converts a given byte array certificate into a readable string for signature or validation purposes.
     *
     * @param certificate The certificate obtained from {@code apiSessionsCertificateGet}
     * @return a String with the certificate in base 64
     */
    public static String convertCertificateToString(byte[] certificate) {
        return new String(certificate).replace("\"", "");
    }

    /**
     * Converts a given byte array toSignHash into a base64 encoded byte array for signature purposes.
     *
     * @param toSignHash the hash used to sign the document
     * @return base64 encoded byte array
     */
    public static byte[] convertToSignHashToByteArray64(byte[] toSignHash) {
        // first we need to convert it to string and then decode as base64
        return Base64.getDecoder().decode(convertCertificateToString(toSignHash));
    }
}
