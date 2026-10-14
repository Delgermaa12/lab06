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