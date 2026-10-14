B232270024  О. Дэлгэрмаа

| Параметр | Сонголт | Төлөөлөх утга |
|---|---|---|
| from | Хүчинтэй / царцаагдсан / байхгүй | Valid, Frozen, Missing |
| to | Хүчинтэй / байхгүй / from-той ижил | Valid, Missing, SameAsFrom |
| amount | Тэг буюу сөрөг / хэвийн / үлдэгдлээс их / өдрийн лимитээс их | Zero, Normal, OverBalance, OverLimit |
| currency | Дансныхтай ижил / өөр | Same, Different |
| Далд орчин | Өдрийн лимитийн үлдэгдэл хангалттай / хүрэлцээгүй | LimitSufficient, LimitInsufficient |

Далд орчны сонголтыг тусад нь авч үзсэн. Учир нь шилжүүлгийн амжилт нь зөвхөн хүсэлтийн параметрүүдээс бус, тухайн дансны үлдэгдэл болон өдрийн лимитийн төлөвөөс хамаарна.


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
| currency Same, Different | энгийн | Хоёулаа зөв ажиллагаа, алдаа биш |

Тооцоо: бүрэн олонлог 3 × 3 × 5 × 2 = 90.
[ERROR]/[SINGLE] утга бүр нэг тест: from 2 + to 2 + amount 4 = 8.
Энгийн утгуудын хослол: 1 × 1 × 1 × 2 = 2.
**90 → 10**


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

Давхар нөхцөлийн тайлбар: 11-р мөрөнд from царцсан бөгөөд to байхгүй. Давуу
эрэмбэ from → to учраас from-ийн алдаа (ERROR_FROZEN) эхлээд гарна.
12-р мөрөнд from байхгүй бөгөөд amount буруу. from эхэлж шалгагддаг тул
ERROR_NO_FROM гарна.

Setup-ийн тэмдэглэл: OverBalance ба OverLimit-ийг ялгаж үзүүлэхийн тулд
тусдаа setup хэрэгтэй. OverBalance дээр үлдэгдэл бага, лимит том. OverLimit
дээр үлдэгдэл хангалттай, лимит бага.

### B1. browser.model

| Хувилбар | Мөрийн тоо |
|---|---|
| Бүрэн олонлог (3×3×2×2×2×2) | 144 |
| 2-way (pairwise) | 10 |
| 3-way | 20 |

2-way дээр PICT 10 мөр өгсөн, лекц дээр гараар 9 мөрөнд багтсан. 9 нь
онолын доод хязгаар (Content ба Cookies хоёр 3 утгатай тул 3×3 = 9 хос
хамгийн багадаа 9 мөр шаардана). PICT greedy алгоритм ашигладаг: алхам бүрдээ
хамгийн олон шинэ хосыг хамарсан мөрийг нэмдэг боловч глобал хамгийн цөөн
мөрийг баталгаажуулдаггүй. Тиймээс оновчтой 9-ээс нэг мөр илүү гарсан.

3-way дээр 20 мөр гарсан нь бүрэн олонлог 144-ийн ойролцоогоор 14%. 2-way
(10 мөр) нь 144-ийн 7% орчим. Хамралтын эрэмбийг нэмэгдүүлэх тусам мөрийн тоо
өснө (10 → 20), гэхдээ бүрэн олонлогоос хамаагүй цөөн хэвээр байна.

