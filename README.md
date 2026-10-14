# Лаб 06 — Category-Partition ба PICT

О. Дэлгэрмаа, B232270024

PICT-ийг эх кодоос нь бүтээсэн (`results/pict-build.txt`). Бүх гаралт `results/` хавтаст байгаа бөгөөд энэ тайланд бичсэн тоо бүр тэдгээр файлаас гарсан.

---

## Хэсэг A. Category-Partition (гараар)

Шалгах функц: `transfer(from, to, amount, currency)`.

### Давуу эрэмбэ

Хүсэлтэд хэд хэдэн алдаа зэрэг байвал **from → to → amount** дарааллаар шалгана гэж үзсэн. Учир нь from данс байхгүй бол үлдсэн шалгалтууд утгагүй болно. amount дотор: BAD_AMOUNT → INSUFFICIENT → LIMIT дарааллаар.

### A1. Сонголт ба төлөөлөх утгууд

| Параметр | Сонголт (дүрмээс) | Төлөөлөх утга |
|---|---|---|
| from | хүчинтэй / царцсан / байхгүй | Valid, Frozen, Missing |
| to | хүчинтэй / байхгүй / from-той ижил | Valid, Missing, SameAsFrom |
| amount | хэвийн / үлдэгдэлтэй яг тэнцүү / ≤ 0 / үлдэгдлээс их / лимитээс их | Normal, ExactBalance, NonPositive, OverBalance, OverLimit |
| currency | дансныхтай ижил / өөр | Same, Different |
| Далд орчин | өдрийн лимитийн үлдэгдэл хангалттай / хүрэлцээгүй | LimitSufficient, LimitInsufficient |

- `Normal` нь эерэг, үлдэгдлээс ихгүй, өдрийн лимитээс ихгүй дүн.
- Үлдэгдэл ба лимитийг хөрвүүлсний дараах дүнгээр шалгана.
- Далд орчныг тусад нь авсан. Учир нь шилжүүлгийн үр дүн нь хүсэлтийн параметрээс гадна дансны үлдэгдэл, өдрийн лимитийн төлөвөөс хамаарна. `OverLimit` тестэд LimitInsufficient, бусад тестэд LimitSufficient төлөвийг setup-аар бэлдэнэ.

### A2. Хязгаарлалтууд

| Утга | Тэмдэглэгээ | Үндэслэл |
|---|---|---|
| from = Valid | энгийн | Бусадтай чөлөөтэй хослоно |
| from = Frozen | [ERROR] | ERROR_FROZEN буцаана, нэг удаа туршина |
| from = Missing | [ERROR] | ERROR_NO_FROM буцаана |
| to = Valid | энгийн | |
| to = Missing | [ERROR] | ERROR_NO_TO буцаана |
| to = SameAsFrom | [ERROR] [IF from ≠ Missing] | ERROR_SAME_ACCOUNT. from байхгүй бол "from-той ижил" утгагүй |
| amount = Normal | энгийн | |
| amount = ExactBalance | [SINGLE] | Хязгаарын утга, алдаа биш. Нэг тест хангалттай |
| amount = NonPositive | [ERROR] | ERROR_BAD_AMOUNT |
| amount = OverBalance | [ERROR] | ERROR_INSUFFICIENT |
| amount = OverLimit | [ERROR] | ERROR_LIMIT |
| currency = Same, Different | энгийн | Хоёулаа зөв ажиллагаа, алдаа биш |

Тооцоо:

- Бүрэн олонлог: 3 × 3 × 5 × 2 = 90.
- [ERROR]/[SINGLE] утга бүр нэг тест: from 2 + to 2 + amount 4 = 8.
- Энгийн утгуудын хослол: 1 × 1 × 1 × 2 = 2.
- **90 → 10**

### A3. Спецификацийн хүснэгт

| № | from | to | amount | currency | Хүлээгдэх үр дүн |
|---|---|---|---|---|---|
| 1 | Valid | Valid | Normal | Same | 201 OK (happy path) |
| 2 | Valid | Valid | Normal | Different | 201 OK (ханшийн хөрвүүлэлттэй) |
| 3 | Frozen | Valid | Normal | Same | ERROR_FROZEN |
| 4 | Missing | Valid | Normal | Same | ERROR_NO_FROM |
| 5 | Valid | Missing | Normal | Same | ERROR_NO_TO |
| 6 | Valid | SameAsFrom | Normal | Same | ERROR_SAME_ACCOUNT |
| 7 | Valid | Valid | NonPositive | Same | ERROR_BAD_AMOUNT |
| 8 | Valid | Valid | OverBalance | Same | ERROR_INSUFFICIENT |
| 9 | Valid | Valid | OverLimit | Same | ERROR_LIMIT |
| 10 | Valid | Valid | ExactBalance | Same | 201 OK ([SINGLE], хязгаарын утга) |
| 11 | Frozen | Missing | Normal | Same | ERROR_FROZEN (давхар нөхцөл) |
| 12 | Missing | Valid | NonPositive | Same | ERROR_NO_FROM (давхар нөхцөл) |

Давхар нөхцөлийн тайлбар:

- 11-р мөрөнд from царцсан бөгөөд to байхгүй. Давуу эрэмбэ from → to учраас from-ийн алдаа (ERROR_FROZEN) эхлээд гарна.
- 12-р мөрөнд from байхгүй бөгөөд amount буруу. from эхэлж шалгагддаг тул ERROR_NO_FROM гарна.

Setup-ийн тэмдэглэл: OverBalance ба OverLimit-ийг ялгаж үзүүлэхийн тулд тусдаа setup хэрэгтэй. OverBalance дээр үлдэгдэл бага, лимит том. OverLimit дээр үлдэгдэл хангалттай, лимит бага.

---

## Хэсэг B. PICT

### B1. browser.model

```text
Content:   Allow, Restrict, Block
Cookies:   Allow, Restrict, Block
Popups:    Yes, No
Addons:    Yes, No
Attacks:   Yes, No
Forgeries: Yes, No
```

```bash
pict browser.model | tee results/browser-2way.txt
pict browser.model /o:3 > results/browser-3way.txt
```

| Хувилбар | Мөрийн тоо |
|---|---|
| Бүрэн олонлог (3×3×2×2×2×2) | 144 |
| 2-way (pairwise) | 10 |
| 3-way | 20 |

2-way дээр PICT 10 мөр өгсөн, лекц дээр гараар 9 мөрөнд багтсан. 9 нь онолын доод хязгаар: Content ба Cookies хоёр 3 утгатай тул 3 × 3 = 9 хос хамгийн багадаа 9 мөр шаардана. PICT greedy алгоритм ашигладаг: алхам бүрдээ хамгийн олон шинэ хосыг хамарсан мөрийг нэмдэг боловч глобал хамгийн цөөн мөрийг баталгаажуулдаггүй. Тиймээс оновчтой 9-ээс нэг мөр илүү гарсан.

3-way дээр 20 мөр гарсан нь бүрэн олонлог 144-ийн ойролцоогоор 14%. 2-way (10 мөр) нь 144-ийн 7% орчим. Хамралтын эрэмбийг нэмэгдүүлэх тусам мөрийн тоо өснө (10 → 20), гэхдээ бүрэн олонлогоос хамаагүй цөөн хэвээр байна.

### B2. Transfer PICT моделиуд

#### B2.1 Гурван модель

`transfer-nc.model` (хязгаарлалтгүй):

```text
From:     Valid, Frozen, Missing
To:       Valid, Missing, SameAsFrom
Amount:   Normal, ExactBalance, NonPositive, OverBalance, OverLimit
Currency: Same, Different
```

`transfer.model` (хязгаарлалттай):

```text
From:     Valid, Frozen, Missing
To:       Valid, Missing, SameAsFrom
Amount:   Normal, ExactBalance, NonPositive, OverBalance, OverLimit
Currency: Same, Different

IF [From] <> "Valid" THEN [Amount] = "Normal";
IF [To] <> "Valid" THEN [Amount] = "Normal";
IF [To] = "SameAsFrom" THEN [From] <> "Missing";
```

`transfer-neg.model` (сөрөг утгатай, `~`):

```text
From:     Valid, ~Frozen, ~Missing
To:       Valid, ~Missing, ~SameAsFrom
Amount:   Normal, ExactBalance, ~NonPositive, ~OverBalance, ~OverLimit
Currency: Same, Different
```

```bash
pict transfer-nc.model  > results/transfer-nc.txt
pict transfer.model     > results/transfer.txt
pict transfer-neg.model > results/transfer-neg.txt
```

#### B2.2 Хязгаарлалтын үндэслэл

- Эхний хоёр нөхцөл: from эсвэл to хүчинтэй биш бол amount-ыг `Normal` болгоно. Ингэвэл дансны алдаа amount-ын алдаатай нэг мөрөнд давхцахгүй (error masking үүсэхгүй).
- Гурав дахь нөхцөл: `To = SameAsFrom` үед `From = Missing` байх хослол утгагүй тул хориглоно.

#### B2.3 Харьцуулалт

Хүснэгтийн тоо бүр `results/` доторх гурван файлаас `awk`-аар тоолсон (`~` тэмдгийг хасаад тоолсон). Алдаатай утга гэдэгт from ≠ Valid, to ≠ Valid, amount ∈ {NonPositive, OverBalance, OverLimit} орно.

<!-- B2_TABLE -->

Ажиглалт:

1. **Мөрийн тоо.** Хязгаарлалтгүй болон хязгаарлалттай моделиуд хоёулаа 15 мөр өгсөн. Хязгаарлалтгүй моделийн доод хязгаар нь Amount (5) × From (3) = 15. Хязгаарлалттай моделийн доод хязгаар: Normal биш 4 amount × 2 currency = 8 мөр (from, to хоёулаа Valid), үлдсэн 7 from × to хос тус бүр 1 мөр, нийт 8 + 7 = 15. Иймд хязгаарлалт нь мөрийн тоог бус **мөрийн агуулгыг** өөрчилдөг.
2. **Error masking.** Хязгаарлалтгүй моделийн гаралтад дансны алдаа ба amount-ын алдаа нэг мөрөнд давхцсан мөр байна (хүснэгтийн 3-р мөр). Ийм мөрөнд яг аль алдаа гарахыг зөвхөн давуу эрэмбээр тодорхойлж болно, тест нь ганц алдааг тусгаарлан шалгахгүй. Хязгаарлалттай болон `~`-тай моделиудад ийм мөр 0.
3. **Нэг мөр дэх алдааны тоо.** Хязгаарлалттай моделиос 3 алдаатай мөр арилсан. Үлдсэн 2 алдаатай мөрүүд нь from ба to хоёулаа буруу хослолууд (хязгаарлалт эдгээрийг хоригложээгүй). Тэдгээрийн oracle-ыг давуу эрэмбээр (from → to) тодорхойлно.
4. **`~` ашигласан загвар.** PICT нэг мөрөнд хамгийн ихдээ нэг сөрөг утга оруулдаг. `transfer-neg` дээр 18 мөр гарсан: 4 нь happy path, үлдсэн 14 нь яг нэг алдаатай. 7 сөрөг утга тус бүр 2 мөрөнд орсон (7 × 2 = 14). Нэг мөрөнд нэг л алдаа байдаг тул дээрх гурван хязгаарлалтыг нэмэх шаардлагагүй. Алдаа давхцах боломжгүй.

#### B2.4 Бодит тест кейсүүд

`results/transfer-neg.txt`-ээс гурван мөр сонгосон.

Setup:

| Данс | Төлөв | Үлдэгдэл | Өдрийн лимит (өнөөдөр шилжүүлсэн 0) |
|---|---|---|---|
| A1 | идэвхтэй | 1000 | 500 |
| A2 | идэвхтэй | 0 | 500 |
| A3 | царцсан | 1000 | 500 |
| A6 | идэвхтэй | 1000 | 300 |

| Кейс | PICT мөр | Оролт | Хүлээгдэх үр дүн (oracle) |
|---|---|---|---|
| 1 (happy path) | Valid, Valid, Normal, Same | from=A1, to=A2, amount=100, currency=MNT | 201 OK |
| 2 (сөрөг: from) | ~Frozen, Valid, Normal, Same | from=A3, to=A2, amount=100, currency=MNT | ERROR_FROZEN |
| 3 (сөрөг: amount) | Valid, Valid, ~OverLimit, Same | from=A6, to=A2, amount=500, currency=MNT | ERROR_LIMIT |

Кейс 3 дээр үлдэгдэл (1000) хангалттай, харин лимит (300) бага тул зөвхөн лимитийн алдаа гарна. Ингэснээр ERROR_INSUFFICIENT-тэй андуурахгүй.

### B3. Дүгнэлт

Гараар хийсэн спецификаци (A3) нь алдааны семантикийг илүү сайн барьдаг. Учир нь [ERROR]/[SINGLE] тэмдэглэгээгээр алдаа бүрийг санаатайгаар тусад нь тусгаарлаж, давуу эрэмбийг нэг бүрчлэн бичсэн. Гэхдээ хүн гараар бүх хосыг шалгаж чаддаггүй, мөн хослол алдагдах эрсдэлтэй. PICT нь параметрийн утга бүрийн хос бүрийг дор хаяж нэг мөрөнд хамруулахыг баталгаажуулдаг бөгөөд 90 хослолыг 15 мөр болгон багасгасан. Харин хязгаарлалтгүй PICT гаралт нь нэг мөрөнд хэд хэдэн алдаа давхцуулж, тест юуг шалгаж байгааг бүдэгрүүлдэг. Хязгаарлалт нэмэх нь үүнийг засдаг боловч хязгаарлалтыг гараар зөв бичих, мөн давуу эрэмбийг мэдэхийг шаарддаг. `~` ашиглах нь хоёр аргын давуу талыг нэгтгэсэн: PICT нэг мөрөнд нэг л алдаа оруулдаг тул A3-ийн "алдаа бүрийг тусад нь шалгах" зарчим автоматаар хэрэгжиж, хязгаарлалт бичих шаардлагагүй болсон. Хамгийн их бодол шаардсан хэсэг нь OverBalance ба OverLimit-ийг ялгахын тулд setup-ыг тусад нь бэлдэх явдал байв. Бодит төсөлд би `~`-тай загвараар алдааны тестүүдийг, хязгаарлалттай загвараар зөв ажиллагааны хослолуудыг үүсгэх байсан.

---

## Репогийн бүтэц

```text
README.md
browser.model
transfer-nc.model
transfer.model
transfer-neg.model
results/
  pict-build.txt
  browser-2way.txt
  browser-3way.txt
  transfer-nc.txt
  transfer.txt
  transfer-neg.txt
```
