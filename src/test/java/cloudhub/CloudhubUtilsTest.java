package cloudhub;

import static org.junit.jupiter.api.Assertions.assertArrayEquals;
import static org.junit.jupiter.api.Assertions.assertEquals;

import java.nio.charset.StandardCharsets;

import org.junit.jupiter.api.Test;

/**
 * Focused unit tests for the hand-maintained {@link CloudhubUtils} helpers that were
 * refactored out of the generated {@code SessionsApi}. These run with no network and no
 * certificate, so they are the fast way to validate this feature in isolation.
 */
class CloudhubUtilsTest {

    @Test
    void convertCertificateToString_stripsSurroundingQuotes() {
        // CloudHub returns the value as a JSON-quoted string; the helper removes the quotes.
        byte[] quoted = "\"aGVsbG8=\"".getBytes(StandardCharsets.UTF_8);
        assertEquals("aGVsbG8=", CloudhubUtils.convertCertificateToString(quoted));
    }

    @Test
    void convertToSignHashToByteArray64_decodesQuotedBase64() {
        // The to-sign hash arrives as a JSON-quoted base64 string; the helper strips the quotes
        // and base64-decodes it. "aGVsbG8=" is base64 for the bytes of "hello".
        byte[] quotedBase64 = "\"aGVsbG8=\"".getBytes(StandardCharsets.UTF_8);
        byte[] expected = "hello".getBytes(StandardCharsets.UTF_8);
        assertArrayEquals(expected, CloudhubUtils.convertToSignHashToByteArray64(quotedBase64));
    }
}
