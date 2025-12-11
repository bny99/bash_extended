
# 🇹🇷 README: JSON Haritası Yönetimi (Bash/JQ)

Bu Bash betiği, `jq` aracını kullanarak bir kabuk değişkeni (`map_degiskeni`) içinde JSON yapısını dinamik olarak yönetmek için bir dizi yardımcı fonksiyon sunar. Özellikle, büyük JSON dosyalarını kabuk argüman limitlerini aşmadan yükleyebilme yeteneği ön plandadır. Ayrıca bash betik dilindeki tek katmanlı map sınırını limitsiz hale getirir.

## 🚀 Temel Fonksiyonlar

Betiğin kalbinde, JSON haritanızı güncelleyen iki ana yükleme mekanizması bulunur: `set_key_v2` (küçük güncellemeler için) ve `import_buyuk_json_to_map` (büyük yükler için).

### 1. `escape_json_string()`

Basit metin dizelerini, `jq` tarafından hatasız işlenebilecek geçerli JSON dizelerine dönüştürür. Özellikle tırnak işaretlerini (`"`) ve ters eğik çizgileri (`\`) kaçırmak için kullanılır.

* **Girdi:** Düzenlenmemiş dize.
* **Çıktı:** JSON kaçış karakterleri uygulanmış dize.

### 2. `set_key_v2 <yol> <değer>`

Küçük JSON verilerini veya basit anahtar/değer çiftlerini haritaya yerleştirmek için kullanılır. Dahili olarak `jq`'nun Argüman mekanizmasını (`--argjson`) kullanır, bu nedenle büyük veri (megabaytlarca) ile çağrılırsa başarısız olabilir.

* **`yol` (dize):** Değerin ekleneceği JSON yolu (`.anahtar`, `.dizi[0]`, `.yeni.anahtar`).
* **`değer` (dize):** Yerleştirilecek basit dize, sayı veya küçük bir JSON objesi/dizisi.

| Örnek Komut | Açıklama |
| :--- | :--- |
| `set_key_v2 ".kullanici.yas" "30"` | `.kullanici.yas` yoluna "30" dizesini atar. |
| `set_key_v2 ".veri" '{"a":1, "b":2}'` | `.veri` yoluna doğrudan JSON objesi atar. |

### 3. `import_buyuk_json_to_map <yol> <dosya_yolu>`

**Büyük JSON dosyalarını güvenli bir şekilde haritaya yüklemek için tasarlanmıştır.** Bash Argüman Limiti'ni aşmak için, `jq`'nun `slurpfile` özelliğini ve kabuk alt sürecini (`<()`) kullanarak dosya içeriğini geçici bir sanal dosya olarak aktarır.

* **`yol` (dize):** Yüklenen içeriğin ekleneceği JSON yolu (Örn: `.yeni_veri`).
* **`dosya_yolu` (dize):** Yüklenecek büyük JSON dosyasının yolu.

| Örnek Komut | Açıklama |
| :--- | :--- |
| `import_buyuk_json_to_map ".api_verisi" "buyuk_liste.json"` | `buyuk_liste.json` içeriğini `.api_verisi` altına yükler. |

***

# 🇬🇧 README: JSON Map Management (Bash/JQ)

This Bash script provides a set of helper functions for dynamically managing a JSON structure within a shell variable (`map_degiskeni`) using the `jq` tool. Its core strength is the ability to load large JSON files without exceeding the restrictive Bash Argument Limit (`Argument List Too Long`). And it makes Bash's one level map variables limitless!

## 🚀 Core Functions

At the heart of the script are two main loading mechanisms for updating your JSON map: `set_key_v2` (for small updates) and `import_buyuk_json_to_map` (for large payloads).

### 1. `escape_json_string()`

Converts simple text strings into valid JSON strings that can be processed by `jq` without errors. It is mainly used to escape quotes (`"`) and backslashes (`\`).

* **Input:** Unprocessed string.
* **Output:** String with JSON escape characters applied.

### 2. `set_key_v2 <path> <value>`

Used to place small JSON data or simple key/value pairs into the map. It internally uses `jq`'s Argument mechanism (`--argjson`), which is why it may fail if called with large data (megabytes).

* **`path` (string):** The JSON path where the value will be added (e.g., `.key`, `.array[0]`, `.new.key`).
* **`value` (string):** The simple string, number, or small JSON object/array to be inserted.

| Example Command | Description |
| :--- | :--- |
| `set_key_v2 ".user.age" "30"` | Assigns the string "30" to the `.user.age` path. |
| `set_key_v2 ".data" '{"a":1, "b":2}'` | Assigns a direct JSON object to the `.data` path. |

### 3. `import_buyuk_json_to_map <path> <file_path>`

**Designed for safely loading large JSON files into the map.** To bypass the Bash Argument Limit, it uses `jq`'s `slurpfile` feature and a shell sub-process (`<()`) to pass the file content as a temporary virtual file.

* **`path` (string):** The JSON path where the loaded content will be added (e.g., `.new_data`).
* **`file_path` (string):** The path to the large JSON file to be loaded.

| Example Command | Description |
| :--- | :--- |
| `import_buyuk_json_to_map ".api_data" "large_list.json"` | Loads the content of `large_list.json` under `.api_data`. |
