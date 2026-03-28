# mTLS 언어별 요청 예제 (Kotlin, C#, C++, PHP)

> Python, Node.js 예제는 메인 SKILL.md를 참조하세요.

## Kotlin 예제

```kotlin
import java.security.KeyStore
import java.security.cert.X509Certificate
import java.security.KeyFactory
import java.security.spec.PKCS8EncodedKeySpec
import java.io.FileReader
import java.io.ByteArrayInputStream
import java.util.Base64
import javax.net.ssl.*

class TLSClient {
    fun createSSLContext(certPath: String, keyPath: String): SSLContext {
        val cert = loadCertificate(certPath)
        val key = loadPrivateKey(keyPath)

        val keyStore = KeyStore.getInstance(KeyStore.getDefaultType())
        keyStore.load(null, null)
        keyStore.setCertificateEntry("client-cert", cert)
        keyStore.setKeyEntry("client-key", key, "".toCharArray(), arrayOf(cert))

        val kmf = KeyManagerFactory.getInstance(KeyManagerFactory.getDefaultAlgorithm())
        kmf.init(keyStore, "".toCharArray())

        return SSLContext.getInstance("TLS").apply {
            init(kmf.keyManagers, null, null)
        }
    }

    private fun loadCertificate(path: String): X509Certificate {
        val content = FileReader(path).readText()
            .replace("-----BEGIN CERTIFICATE-----", "")
            .replace("-----END CERTIFICATE-----", "")
            .replace("\\s".toRegex(), "")
        val bytes = Base64.getDecoder().decode(content)
        return CertificateFactory.getInstance("X.509")
            .generateCertificate(ByteArrayInputStream(bytes)) as X509Certificate
    }

    private fun loadPrivateKey(path: String): java.security.PrivateKey {
        val content = FileReader(path).readText()
            .replace("-----BEGIN PRIVATE KEY-----", "")
            .replace("-----END PRIVATE KEY-----", "")
            .replace("\\s".toRegex(), "")
        val bytes = Base64.getDecoder().decode(content)
        val spec = PKCS8EncodedKeySpec(bytes)
        return KeyFactory.getInstance("RSA").generatePrivate(spec)
    }

    fun makeRequest(url: String, context: SSLContext): String {
        val connection = (URL(url).openConnection() as HttpsURLConnection).apply {
            sslSocketFactory = context.socketFactory
            requestMethod = "GET"
            connectTimeout = 5000
            readTimeout = 5000
        }

        return connection.inputStream.bufferedReader().use { it.readText() }.also {
            connection.disconnect()
        }
    }
}

fun main() {
    val client = TLSClient()
    val context = client.createSSLContext("/path/to/client-cert.pem", "/path/to/client-key.pem")
    val response = client.makeRequest("https://apps-in-toss-api.toss.im/endpoint", context)
    println(response)
}
```

## C# 예제

```csharp
using System;
using System.Net.Http;
using System.Security.Cryptography.X509Certificates;
using System.Threading.Tasks;

class Program {
    static async Task Main(string[] args) {
        var handler = new HttpClientHandler();
        handler.ClientCertificates.Add(
            new X509Certificate2("/path/to/client-cert.pem")
        );

        using var client = new HttpClient(handler);
        var response = await client.GetAsync("https://apps-in-toss-api.toss.im/endpoint");
        string body = await response.Content.ReadAsStringAsync();
        Console.WriteLine(body);
    }
}
```

## C++ 예제 (libcurl 사용)

```cpp
#include <curl/curl.h>
#include <iostream>
#include <string>

size_t WriteCallback(void* contents, size_t size, size_t nmemb, std::string* userp) {
    userp->append((char*)contents, size * nmemb);
    return size * nmemb;
}

int main() {
    CURL* curl = curl_easy_init();
    if (curl) {
        std::string response;
        curl_easy_setopt(curl, CURLOPT_URL, "https://apps-in-toss-api.toss.im/endpoint");
        curl_easy_setopt(curl, CURLOPT_SSLCERT, "/path/to/client-cert.pem");
        curl_easy_setopt(curl, CURLOPT_SSLKEY, "/path/to/client-key.pem");
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);

        CURLcode res = curl_easy_perform(curl);
        if (res == CURLE_OK) {
            std::cout << "Response: " << response << std::endl;
        } else {
            std::cerr << "Error: " << curl_easy_strerror(res) << std::endl;
        }

        curl_easy_cleanup(curl);
    }

    return 0;
}
```

## PHP 예제

```php
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, 'https://apps-in-toss-api.toss.im/endpoint');
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_SSLCERT, '/path/to/client-cert.pem');
curl_setopt($ch, CURLOPT_SSLKEY, '/path/to/client-key.pem');

$response = curl_exec($ch);
curl_close($ch);
```
