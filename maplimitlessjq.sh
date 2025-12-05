#!/bin/bash

# =======================================================
# 1. TEMEL DEĞİŞKEN TANIMI
# =======================================================
# Harita değişkenini başlangıçta boş bir JSON nesnesi olarak tanımlayın
map_degiskeni='{}' 

# =======================================================
# 2. TEMEL YARDIMCI FONKSİYONLAR (Orijinal Koddan - Değişmedi)
# =======================================================

# JSON'daki basit karakterleri kaçırmak için yardımcı fonksiyon (Gereklidir)
escape_json_string() {
    echo "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

# set_key_v2: Herhangi bir değeri harita içine yerleştirir. 
# (Büyük veri ile başarısız olur, ancak küçük veri için korunmalıdır)
set_key_v2() {
    local path="$1"
    local value="$2"
    local new_content=""
    
    # JSON objesi/dizisi veya basit dize atama mantığı... (Orijinal Kod)
    if [[ "$value" =~ ^\{.*\}$ ]] || [[ "$value" =~ ^\[.*\]$ ]]; then
        new_content=$(echo "$map_degiskeni" | jq --argjson new_value "$value" "${path} = \$new_value" 2>/dev/null)
    else
        local escaped_value
        escaped_value=$(escape_json_string "$value")
        new_content=$(echo "$map_degiskeni" | jq "${path} = \"${escaped_value}\"" 2>/dev/null)
    fi
    
    if [ $? -eq 0 ] && [ -n "$new_content" ]; then
        map_degiskeni="$new_content"
        return 0
    else
        echo "🚨 HATA! set_key_v2 Başarısız: Yol: $path (Olası Argüman Limiti)" >&2
        return 1
    fi
}

# import_json_to_map: Orijinal dosya yükleme yordamı (Küçük dosyalar için).
import_json_to_map() {
    local path="$1"
    local json_file_content=$(cat "$2")
    set_key_v2 "$path" "$json_file_content"
}

# =======================================================
# 3. GÜVENLİ BÜYÜK VERİ FONKSİYONU (xy-en-güvenli mantığı)
# =======================================================

# Bu fonksiyon, Argüman Limiti'ni aşmak için tasarlanmış tek ve güvenli yoldur.
import_buyuk_json_to_map() {
    local path="$1"
    local JSON_DOSYASI="$2"
    local YENI_MAP=""
    
    # 1. Güvenli JQ Güncellemesi (Sizin xy-en-güvenli v13 mantığınız)
    # SANAL DOSYA YÖNTEMİ: JQ'ya büyük veriyi sanal bir dosya olarak gösterir.
    YENI_MAP=$(echo "$map_degiskeni" | \
               jq --slurpfile data <(cat "$JSON_DOSYASI" | jq -R -s '.' | jq -c '.' 2>/dev/null) \
                  'fromjson? // {} | .silxb = $data[0]' 2>/dev/null)

    # 2. Hata Kontrolü ve Global Atama
    if [ $? -eq 0 ] && [ -n "$YENI_MAP" ]; then
        map_degiskeni="$YENI_MAP"
        echo "✅ Başarılı: Büyük JSON yükü '$path' yoluna eklendi."
        return 0
    else
        echo "❌ HATA: Büyük JSON yüklemesi başarısız oldu. Harita korunmuştur." >&2
        return 1
    fi
}

# =======================================================
# 4. TEST ALANI
# =======================================================

echo "--- Örnek Çalıştırma ---"

# 1. Başlangıç Haritası
map_degiskeni='{"kullanici.id": 100, "ayarlar.dil": "tr"}'
echo "Başlangıç Haritası (Önce):"
echo "$map_degiskeni" | jq '.'

# 2. BÜYÜK JSON YÜKLEMESİ (Bu fonksiyonu kullanın)
# SADECE BÜYÜK DOSYALAR İÇİN:
# import_buyuk_json_to_map ".silxb" "tilk/xsila.json" 

# 3. Sonuç Kontrolü
# echo "Son Harita (Sonra):"
# echo "$map_degiskeni" | jq '.'
